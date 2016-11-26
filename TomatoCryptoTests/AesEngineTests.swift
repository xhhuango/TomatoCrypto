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
            "6B576D48", "65387849", "73447066", "7A4B3464",
            "D94F2E92", "BC7756DB", "CF3326BD", "B57812D9",
            "67861B47", "DBF14D9C", "14C26B21", "A1BA79F8",
            "97305A75", "4CC117E9", "58037CC8", "F9B90530",
            "C95B5EEC", "859A4905", "DD9935CD", "242030FD",
            "6E5F0ADA", "EBC543DF", "365C7612", "127C46EF",
            "5E05D513", "B5C096CC", "839CE0DE", "91E0A631",
            "FF211292", "4AE1845E", "C97D6480", "589DC2B1",
            "2104DAF8", "6BE55EA6", "A2983A26", "FA05F897",
            "514552D5", "3AA00C73", "98383655", "623DCEC2",
            "40CE777F", "7A6E7B0C", "E2564D59", "806B839B",
            ]
        
        do {
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            for (subkey, aesSubkey) in zip(subkeys, aes.subkeys) {
                XCTAssertEqual(hexToBytes(hex: subkey), aesSubkey)
            }
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testKeySchedule192() {
        let key = "kWmHe8xIsDpfzK4dqwertyui"
        let subkeys = [
            "6B576D48", "65387849", "73447066", "7A4B3464",
            "71776572", "74797569", "DCCA94DA", "B9F2EC93",
            "CAB69CF5", "B0FDA891", "C18ACDE3", "B5F3B88A",
            "D3A6EA0F", "6A54069C", "A0E29A69", "101F32F8",
            "D195FF1B", "64664791", "E4066B4C", "8E526DD0",
            "2EB0F7B9", "3EAFC541", "EF3A3A5A", "8B5C7DCB",
            "A6F97471", "28AB19A1", "061BEE18", "38B42B59",
            "D78E1103", "5CD26CC8", "03A99C3B", "2B02859A",
            "2D196B82", "15AD40DB", "C22351D8", "9EF13D10",
            "828E5630", "A98CD3AA", "8495B828", "9138F8F3",
            "531BA92B", "CDEA943B", "45ACB48D", "EC206727",
            "68B5DF0F", "F98D27FC", "AA968ED7", "677C1AEC",
            "D50E7A08", "392E1D2F", "519BC220", "A816E5DC"
        ]
        
        do {
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            for (subkey, aesSubkey) in zip(subkeys, aes.subkeys) {
                XCTAssertEqual(hexToBytes(hex: subkey), aesSubkey)
            }
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testKeySchedule256() {
        let key = "kWmHe8xIsDpfzK4dqwertyuiasdfghjk"
        let subkeys = [
            "6B576D48", "65387849", "73447066", "7A4B3464",
            "71776572", "74797569", "61736466", "67686A6B",
            "2F5512CD", "4A6D6A84", "39291AE2", "43622E86",
            "6BDD5436", "1FA4215F", "7ED74539", "19BF2F52",
            "25401219", "6F2D789D", "5604627F", "15664CF9",
            "32EE7DAF", "2D4A5CF0", "539D19C9", "4A22369B",
            "B24506CF", "DD687E52", "8B6C1C2D", "9E0A50D4",
            "39892EE7", "14C37217", "475E6BDE", "0D7C5D45",
            "AA096818", "7761164A", "FC0D0A67", "62075AB3",
            "934C908A", "878FE29D", "C0D18943", "CDADD406",
            "2F4107A5", "582011EF", "A42D1B88", "C62A413B",
            "27A91368", "A026F1F5", "60F778B6", "AD5AACB0",
            "B1D0E030", "E9F0F1DF", "4DDDEA57", "8BF7AB6C",
            "1AC17138", "BAE780CD", "DA10F87B", "774A54CB",
            "27F0FFC5", "CE000E1A", "83DDE44D", "082A4F21"
        ]
        
        do {
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            for (subkey, aesSubkey) in zip(subkeys, aes.subkeys) {
                XCTAssertEqual(hexToBytes(hex: subkey), aesSubkey)
            }
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testEncryptBlock128() {
        let key = "kWmHe8xIsDpfzK4d"
        let plaintext = "4865792C2048656C6C6F20776F726C64"
        let ciphertext = "7832E84682951FB5B02548F2FEB9BB9E"
        
        do {
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: hexToBytes(hex: plaintext), inputOffset: 0, output: &encrypted, outputOffset: 0)
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
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: hexToBytes(hex: plaintext), inputOffset: 0, output: &encrypted, outputOffset: 0)
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
            let aes = AesEngine()
            try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: hexToBytes(hex: plaintext), inputOffset: 0, output: &encrypted, outputOffset: 0)
            XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock128() {
        let key = SecretKey(bytes: stringToBytes(string: "kWmHe8xIsDpfzK4d"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let aes = AesEngine()
            
            try aes.initialize(processMode: .encryption, key: key)
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: plaintextBytes, inputOffset: 0, output: &encrypted, outputOffset: 0)
            
            try aes.initialize(processMode: .decryption, key: key)
            var decrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: encrypted, inputOffset: 0, output: &decrypted, outputOffset: 0)
            XCTAssertEqual(decrypted, plaintextBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock192() {
        let key = SecretKey(bytes: stringToBytes(string: "kWmHe8xIsDpfzK4dqwertyui"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let aes = AesEngine()
            
            try aes.initialize(processMode: .encryption, key: key)
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: plaintextBytes, inputOffset: 0, output: &encrypted, outputOffset: 0)
            
            try aes.initialize(processMode: .decryption, key: key)
            var decrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: encrypted, inputOffset: 0, output: &decrypted, outputOffset: 0)
            XCTAssertEqual(decrypted, plaintextBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock256() {
        let key = SecretKey(bytes: stringToBytes(string: "kWmHe8xIsDpfzK4dqwertyuiasdfghjk"))
        let plaintext = "Hey, Hello world"
        
        let plaintextBytes = stringToBytes(string: plaintext)
        
        do {
            let aes = AesEngine()
            
            try aes.initialize(processMode: .encryption, key: key)
            var encrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: plaintextBytes, inputOffset: 0, output: &encrypted, outputOffset: 0)
            
            try aes.initialize(processMode: .decryption, key: key)
            var decrypted = [Byte](repeating: 0, count: aes.blockSize)
            try aes.processBlock(input: encrypted, inputOffset: 0, output: &decrypted, outputOffset: 0)
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
                try aes.initialize(processMode: .encryption, key: SecretKey(bytes: stringToBytes(string: key)))
                var encrypted = [Byte](repeating: 0, count: aes.blockSize)
                try aes.processBlock(input: hexToBytes(hex: plaintext), inputOffset: 0, output: &encrypted, outputOffset: 0)
                XCTAssertEqual(encrypted, hexToBytes(hex: ciphertext))
            } catch let error {
                XCTFail("\(error)")
            }
        }
    }
}
