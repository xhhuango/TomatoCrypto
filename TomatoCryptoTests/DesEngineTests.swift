import XCTest
@testable import TomatoCrypto

class DesEngineTests: XCTestCase {
    private let des = DesEngine()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetBit() {
        let bytes1: [Byte] = [0x85, 0x88]
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 0), true)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 2), false)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 3), false)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 7), true)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 8), true)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 11), false)
        XCTAssertEqual(self.des.getBit(bytes: bytes1, index: 15), false)
    }
    
    func testSetBit() {
        var byte1: [Byte] = [0x00, 0x00]
        self.des.setBit(bytes: &byte1, index: 0, bit: true)
        self.des.setBit(bytes: &byte1, index: 4, bit: true)
        self.des.setBit(bytes: &byte1, index: 8, bit: true)
        XCTAssertEqual(byte1, [0x88, 0x80])
    }
    
    func testPermute() {
        let key1 = "0100000000000000"
        let permuted1 = "00000000000000"
        let key1Bytes = hexToBytes(hex: key1)
        let permuted1Bytes = hexToBytes(hex: permuted1)
        XCTAssertEqual(self.des.permute(bytes: key1Bytes, table: self.des.pc1), permuted1Bytes)
        
        let key2 = "0200000000000000"
        let permuted2 = "00000000100000"
        let key2Bytes = hexToBytes(hex: key2)
        let permuted2Bytes = hexToBytes(hex: permuted2)
        XCTAssertEqual(self.des.permute(bytes: key2Bytes, table: self.des.pc1), permuted2Bytes)
        
        let key3 = "0400000000000000"
        let permuted3 = "00000000001000"
        let key3Bytes = hexToBytes(hex: key3)
        let permuted3Bytes = hexToBytes(hex: permuted3)
        XCTAssertEqual(self.des.permute(bytes: key3Bytes, table: self.des.pc1), permuted3Bytes)
        
        let key4 = "0800000000000000"
        let permuted4 = "00000000000010"
        let key4Bytes = hexToBytes(hex: key4)
        let permuted4Bytes = hexToBytes(hex: permuted4)
        XCTAssertEqual(self.des.permute(bytes: key4Bytes, table: self.des.pc1), permuted4Bytes)
        
        let key5 = "123456789ABCDEF0"
        let permuted5 = "F0CCAAF556678F"
        let key5Bytes = hexToBytes(hex: key5)
        let permuted5Bytes = hexToBytes(hex: permuted5)
        XCTAssertEqual(self.des.permute(bytes: key5Bytes, table: self.des.pc1), permuted5Bytes)
    }
    
    func testLeftShift() {
        let c = "F0CCAAF0"
        let d = "556678F0"
        
        let subC = ["E19955F0", "C332ABF0", "0CCAAFF0", "332ABFC0",
                    "CCAAFF00", "32ABFC30", "CAAFF0C0", "2ABFC330",
                    "557F8660", "55FE1990", "57F86650", "5FE19950",
                    "7F866550", "FE199550", "F8665570", "F0CCAAF0"]
        
        let subD = ["AACCF1E0", "5599E3D0", "56678F50", "599E3D50",
                    "6678F550", "99E3D550", "678F5560", "9E3D5590",
                    "3C7AAB30", "F1EAACC0", "C7AAB330", "1EAACCF0",
                    "7AAB33C0", "EAACCF10", "AAB33C70", "556678F0"]
        
        var cBytes = hexToBytes(hex: c)
        var dBytes = hexToBytes(hex: d)
        for i in 0..<self.des.shift.count {
            cBytes = self.des.leftShift(bytes: cBytes, bitCount: 28, shiftCount: self.des.shift[i])
            XCTAssertEqual(cBytes, hexToBytes(hex: subC[i]), "c round=\(i)")
            dBytes = self.des.leftShift(bytes: dBytes, bitCount: 28, shiftCount: self.des.shift[i])
            XCTAssertEqual(dBytes, hexToBytes(hex: subD[i]), "d round=\(i)")
        }
    }
    
    func testKeySchedule() {
        let key = "123456789ABCDEF0"
        let subkeys = ["1B02EFFC7072", "79AED9DBC9E5", "55FC8A42CF99", "72ADD6DB351D",
                       "7CEC07EB53A8", "63A53E507B2F", "EC84B7F618BC", "F78A3AC13BFB",
                       "E0DBEBEDE781", "B1F347BA464F", "215FD3DED386", "7571F59467E9",
                       "97C5D1FABA41", "5F43B7F2E73A", "BF918D3D3F0A", "CB3D8B0E17F5"]
        
        let keyBytes = hexToBytes(hex: key)
        let subkeysBytes = self.des.keySchedule(key: keyBytes)
        for i in 0..<subkeysBytes.count {
            XCTAssertEqual(subkeysBytes[i], hexToBytes(hex: subkeys[i]))
        }
    }
    
    func testFFunction() {
        let r1 = "00000000"
        let k1 = "1B02EFFC7072"
        let out1 = "223340F3"
        XCTAssertEqual(self.des.fFunction(right: hexToBytes(hex: r1), key: hexToBytes(hex: k1)), hexToBytes(hex: out1))
        
        let r2 = "223340F3"
        let k2 = "79AED9DBC9E5"
        let out2 = "79DA1E65"
        XCTAssertEqual(self.des.fFunction(right: hexToBytes(hex: r2), key: hexToBytes(hex: k2)), hexToBytes(hex: out2))
    }
    
    func testRound() {
        let l1 = "00000000"
        let r1 = "00000000"
        let k1 = "1B02EFFC7072"
        let out1 = "223340F3"
        XCTAssertEqual(self.des.round(left: hexToBytes(hex: l1), right: hexToBytes(hex: r1), key: hexToBytes(hex: k1)), hexToBytes(hex: out1))
        
        let l2 = "223340F3"
        let r2 = "79DA1E65"
        let k2 = "55FC8A42CF99"
        let out2 = "24AB1EC6"
        XCTAssertEqual(self.des.round(left: hexToBytes(hex: l2), right: hexToBytes(hex: r2), key: hexToBytes(hex: k2)), hexToBytes(hex: out2))
    }
    
    func testEncryptBlock() {
        let key = SecretKey(bytes: hexToBytes(hex: "123456789ABCDEF0"))
        let plain = "0000000000000000"
        let cipher = "948A43F98A834F7E"
        
        do {
            let des = DesEngine()
            try des.initialize(processMode: .encryption, key: key)
            XCTAssertEqual(try des.processBlock(input: hexToBytes(hex: plain)), hexToBytes(hex: cipher))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock() {
        let key = SecretKey(bytes: hexToBytes(hex: "123456789ABCDEF0"))
        let plain = "0000000000000000"
        let cipher = "948A43F98A834F7E"
        
        let plainBytes = hexToBytes(hex: plain)
        
        do {
            let des = DesEngine()
            
            try des.initialize(processMode: .encryption, key: key)
            let encrypted = try des.processBlock(input: plainBytes)
            XCTAssertEqual(encrypted, hexToBytes(hex: cipher))
            
            try des.initialize(processMode: .decryption, key: key)
            let decrypted = try des.processBlock(input: encrypted)
            XCTAssertEqual(decrypted, plainBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
