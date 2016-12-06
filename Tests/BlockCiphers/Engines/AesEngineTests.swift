import XCTest
@testable import TomatoCrypto

class AesEngineTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testKeySchedule128() {
        let key = "kWmHe8xIsDpfzK4d"
        let subkeys = [
            "6B576D4865387849734470667A4B3464",
            "D94F2E92BC7756DBCF3326BDB57812D9",
            "67861B47DBF14D9C14C26B21A1BA79F8",
            "97305A754CC117E958037CC8F9B90530",
            "C95B5EEC859A4905DD9935CD242030FD",
            "6E5F0ADAEBC543DF365C7612127C46EF",
            "5E05D513B5C096CC839CE0DE91E0A631",
            "FF2112924AE1845EC97D6480589DC2B1",
            "2104DAF86BE55EA6A2983A26FA05F897",
            "514552D53AA00C7398383655623DCEC2",
            "40CE777F7A6E7B0CE2564D59806B839B",
            ]
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])
            
            var engineSubkeyStrngs: [String] = []
            for engineSubkey in engine.subkeys {
                let res = engineSubkey.withUnsafeBytes({ $0 }).baseAddress!.assumingMemoryBound(to: Byte.self)
                engineSubkeyStrngs.append("\(bytesToHex(bytes: res, count: 16))")
            }
            
            XCTAssertEqual(engineSubkeyStrngs, subkeys)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testKeySchedule192() {
        let key = "kWmHe8xIsDpfzK4dqwertyui"
        let subkeys = [
            "6B576D4865387849734470667A4B3464",
            "7177657274797569DCCA94DAB9F2EC93",
            "CAB69CF5B0FDA891C18ACDE3B5F3B88A",
            "D3A6EA0F6A54069CA0E29A69101F32F8",
            "D195FF1B64664791E4066B4C8E526DD0",
            "2EB0F7B93EAFC541EF3A3A5A8B5C7DCB",
            "A6F9747128AB19A1061BEE1838B42B59",
            "D78E11035CD26CC803A99C3B2B02859A",
            "2D196B8215AD40DBC22351D89EF13D10",
            "828E5630A98CD3AA8495B8289138F8F3",
            "531BA92BCDEA943B45ACB48DEC206727",
            "68B5DF0FF98D27FCAA968ED7677C1AEC",
            "D50E7A08392E1D2F519BC220A816E5DC"
        ]
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])

            var engineSubkeyStrngs: [String] = []
            for engineSubkey in engine.subkeys {
                let res = engineSubkey.withUnsafeBytes({ $0 }).baseAddress!.assumingMemoryBound(to: Byte.self)
                engineSubkeyStrngs.append("\(bytesToHex(bytes: res, count: 16))")
            }
            
            XCTAssertEqual(engineSubkeyStrngs, subkeys)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testKeySchedule256() {
        let key = "kWmHe8xIsDpfzK4dqwertyuiasdfghjk"
        let subkeys = [
            "6B576D4865387849734470667A4B3464",
            "71776572747975696173646667686A6B",
            "2F5512CD4A6D6A8439291AE243622E86",
            "6BDD54361FA4215F7ED7453919BF2F52",
            "254012196F2D789D5604627F15664CF9",
            "32EE7DAF2D4A5CF0539D19C94A22369B",
            "B24506CFDD687E528B6C1C2D9E0A50D4",
            "39892EE714C37217475E6BDE0D7C5D45",
            "AA0968187761164AFC0D0A6762075AB3",
            "934C908A878FE29DC0D18943CDADD406",
            "2F4107A5582011EFA42D1B88C62A413B",
            "27A91368A026F1F560F778B6AD5AACB0",
            "B1D0E030E9F0F1DF4DDDEA578BF7AB6C",
            "1AC17138BAE780CDDA10F87B774A54CB",
            "27F0FFC5CE000E1A83DDE44D082A4F21"
        ]
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])

            var engineSubkeyStrngs: [String] = []
            for engineSubkey in engine.subkeys {
                let res = engineSubkey.withUnsafeBytes({ $0 }).baseAddress!.assumingMemoryBound(to: Byte.self)
                engineSubkeyStrngs.append("\(bytesToHex(bytes: res, count: 16))")
            }
            
            XCTAssertEqual(engineSubkeyStrngs, subkeys)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testEncryptBlock128() {
        let key = "kWmHe8xIsDpfzK4d"
        let plaintext = "4865792C2048656C6C6F20776F726C64"
        let ciphertext = "7832E84682951FB5B02548F2FEB9BB9E"
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])

            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: hexToBytes(hex: plaintext), output: &encrypted)
            XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    
    func testEncryptBlock192() {
        let key = "kWmHe8xIsDpfzK4dqwertyui"
        let plaintext = "4865792C2048656C6C6F20776F726C64"
        let ciphertext = "8630A1C12C8FDE8247678E42E1DA9B49"
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])

            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: hexToBytes(hex: plaintext), output: &encrypted)
            XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testEncryptBlock256() {
        let key = "kWmHe8xIsDpfzK4dqwertyuiasdfghjk"
        let plaintext = "4865792C2048656C6C6F20776F726C64"
        let ciphertext = "559B77F2C20209502A1F77CE7CEC0611"
        
        do {
            let engine = AesEngine()
            let keyParam = SimpleSecretKeyParameter(key: stringToBytes(string: key))
            try engine.initialize(isEncryption: true, parameters: [keyParam])

            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: hexToBytes(hex: plaintext), output: &encrypted)
            XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock128() {
        let key = SimpleSecretKeyParameter(key: stringToBytes(string: "kWmHe8xIsDpfzK4d"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let engine = AesEngine()

            try engine.initialize(isEncryption: true, parameters: [key])
            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: plaintextBytes, output: &encrypted)

            try engine.initialize(isEncryption: false, parameters: [key])
            var decrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: encrypted, output: &decrypted)
            XCTAssertEqual(decrypted, plaintextBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock192() {
        let key = SimpleSecretKeyParameter(key: stringToBytes(string: "kWmHe8xIsDpfzK4dqwertyui"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let engine = AesEngine()

            try engine.initialize(isEncryption: true, parameters: [key])
            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: plaintextBytes, output: &encrypted)

            try engine.initialize(isEncryption: false, parameters: [key])
            var decrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: encrypted, output: &decrypted)
            XCTAssertEqual(decrypted, plaintextBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock256() {
        let key = SimpleSecretKeyParameter(key: stringToBytes(string: "kWmHe8xIsDpfzK4dqwertyuiasdfghjk"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let engine = AesEngine()

            try engine.initialize(isEncryption: true, parameters: [key])
            var encrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: plaintextBytes, output: &encrypted)

            try engine.initialize(isEncryption: false, parameters: [key])
            var decrypted = [Byte](repeating: 0, count: engine.blockSize)
            try engine.processBlock(input: encrypted, output: &decrypted)
            XCTAssertEqual(decrypted, plaintextBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testPerformanceEncrypt128() {
        self.measure {
            let key = "kWmHe8xIsDpfzK4d"
            let plaintext = "4865792C2048656C6C6F20776F726C64"
            let ciphertext = "7832E84682951FB5B02548F2FEB9BB9E"
            
            do {
                let aes = AesEngine()
                let secret = SimpleSecretKeyParameter(key: stringToBytes(string: key))
                try aes.initialize(isEncryption: true, parameters: [secret])
                var encrypted = [Byte](repeating: 0, count: aes.blockSize)
                try aes.processBlock(input: hexToBytes(hex: plaintext), output: &encrypted)
                XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
            } catch let error {
                XCTFail("\(error)")
            }
        }
    }
}
