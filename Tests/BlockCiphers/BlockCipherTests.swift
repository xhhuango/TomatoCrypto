import XCTest
@testable import TomatoCrypto

class BlockCipherTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBlockCipher1() {
        let key = SimpleSecretKeyParameter(key: hexToBytes(hex: "2b7e151628aed2a6abf7158809cf4f3c"))
        let plaintext = hexToBytes(hex: "6bc1bee22e409f96e93d7e117393172a" + "ae2d8a571e03ac9c9eb76fac45af8e51" +
                                        "30c81c46a35ce411e5fbc1191a0a52ef" + "f69f2445df4f9b17ad2b417be66c3710")
        let ciphertext = hexToBytes(hex: "3ad77bb40d7a3660a89ecaf32466ef97" + "f5d3d58503b9699de785895a96fdbaaf" +
                                         "43b1cd7f598ece23881b00e3ed030688" + "7b0c785e27e8ad3f8223207104725dd4")

        do {
            let cipher = BlockCipher(engine: EcbMode(engine: AesEngine()), padding: NoPadding())

            try cipher.initialize(isEncryption: true, parameters: [key])
            let encrypted = try cipher.finalize(input: plaintext)
            XCTAssertEqual(encrypted, ciphertext)

            try cipher.initialize(isEncryption: false, parameters: [key])
            let decrypted = try cipher.finalize(input: encrypted)
            XCTAssertEqual(decrypted, plaintext)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testBlockCipher2() {
        let key = SimpleSecretKeyParameter(key: hexToBytes(hex: "2b7e151628aed2a6abf7158809cf4f3c"))
        let plaintext1 = hexToBytes(hex: "6bc1bee22e409f96e93d7e117393172a" + "ae2d8a571e03ac9c9eb76fac45af8e51")
        let plaintext2 = hexToBytes(hex: "30c81c46a35ce411e5fbc1191a0a52ef" + "f69f2445df4f9b17ad2b417be66c3710")
        let ciphertext1 = hexToBytes(hex: "3ad77bb40d7a3660a89ecaf32466ef97" + "f5d3d58503b9699de785895a96fdbaaf")
        let ciphertext2 = hexToBytes(hex: "43b1cd7f598ece23881b00e3ed030688" + "7b0c785e27e8ad3f8223207104725dd4")

        do {
            let cipher = BlockCipher(engine: EcbMode(engine: AesEngine()), padding: NoPadding())

            try cipher.initialize(isEncryption: true, parameters: [key])
            let encrypted1 = try cipher.update(input: plaintext1)
            let encrypted2 = try cipher.finalize(input: plaintext2)
            XCTAssertEqual(encrypted1, ciphertext1)
            XCTAssertEqual(encrypted2, ciphertext2)

            try cipher.initialize(isEncryption: false, parameters: [key])
            let decrypted1 = try cipher.update(input: encrypted1)
            let decrypted2 = try cipher.finalize(input: encrypted2)
            XCTAssertEqual(decrypted1, plaintext1)
            XCTAssertEqual(decrypted2, plaintext2)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
