import XCTest
@testable import TomatoCrypto

class Pkcs7PaddingTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPkcs7Padding() {
        let key = hexToBytes(hex: "ac5800ac3cb59c7c14f36019e43b44fe")
        let iv = hexToBytes(hex: "f013ce1ec901b5b60a85a986b3b72eba")
        let plaintext = hexToBytes(hex: "f6cee5ff28fd")
        let ciphertext = hexToBytes(hex: "e8a846fd9718507371604504d4ca1ac7")

        let keyParam = SimpleSecretKeyParameter(key: key)
        let ivParam = IvParameter(iv: iv)

        do {
            let cipher = BlockCipher(engine: CbcMode(engine: AesEngine()), padding: Pkcs7Padding())

            try cipher.initialize(isEncryption: true, parameters: [keyParam, ivParam])
            let encrypted = try cipher.finalize(input: plaintext)
            XCTAssertEqual(encrypted, ciphertext)

            try cipher.initialize(isEncryption: false, parameters: [keyParam, ivParam])
            let decrypted = try cipher.finalize(input: encrypted)
            XCTAssertEqual(decrypted, plaintext)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
