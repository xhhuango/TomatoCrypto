import XCTest
@testable import TomatoCrypto

class CtrModeTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAes128() {
        let key = SimpleSymmetricKeyParameter(key: hexToBytes(hex: "2b7e151628aed2a6abf7158809cf4f3c"))
        let iv = IvParameter(iv: hexToBytes(hex: "f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff"))
        let plaintext = hexToBytes(hex: "6bc1bee22e409f96e93d7e117393172a" + "ae2d8a571e03ac9c9eb76fac45af8e51" +
                                        "30c81c46a35ce411e5fbc1191a0a52ef" + "f69f2445df4f9b17ad2b417be66c3710")
        let ciphertext = hexToBytes(hex: "874d6191b620e3261bef6864990db6ce" + "9806f66b7970fdff8617187bb9fffdff" +
                                         "5ae4df3edbd5d35e5b4f09020db03eab" + "1e031dda2fbe03d1792170a0f3009cee")
        
        do {
            let cipher = SymmetricBlockCipher(engine: CtrMode(engine: AesEngine()))

            try cipher.initialize(isEncryption: true, parameters: [key, iv])
            let encrypted = try cipher.process(input: plaintext)
            XCTAssertEqual(encrypted, ciphertext)

            try cipher.initialize(isEncryption: false, parameters: [key, iv])
            let decrypted = try cipher.process(input: encrypted)
            XCTAssertEqual(decrypted, plaintext)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
