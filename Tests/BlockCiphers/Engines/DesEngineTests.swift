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

    func testEncryptBlock() {
        let key = SimpleSecretKeyParameter(key: hexToBytes(hex: "123456789ABCDEF0"))
        let plain = "0000000000000000"
        let cipher = "948A43F98A834F7E"
        
        do {
            let des = DesEngine()
            try des.initialize(isEncryption: true, parameters: [key])
            var encrypted = [Byte](repeating: 0, count: des.blockSize)
            try des.processBlock(input: hexToBytes(hex: plain), output: &encrypted)
            XCTAssertEqual(encrypted, hexToBytes(hex: cipher))
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testDecryptBlock() {
        let key = SimpleSecretKeyParameter(key: hexToBytes(hex: "123456789ABCDEF0"))
        let plain = "0000000000000000"
        let cipher = "948A43F98A834F7E"
        
        let plainBytes = hexToBytes(hex: plain)
        
        do {
            let des = DesEngine()
            
            try des.initialize(isEncryption: true, parameters: [key])
            
            var encrypted = [Byte](repeating: 0, count: des.blockSize)
            try des.processBlock(input: plainBytes, output: &encrypted)
            XCTAssertEqual(encrypted, hexToBytes(hex: cipher))
            
            try des.initialize(isEncryption: false, parameters: [key])
            var decrypted = [Byte](repeating: 0, count: des.blockSize)
            try des.processBlock(input: encrypted, output: &decrypted)
            XCTAssertEqual(decrypted, plainBytes)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
