import XCTest
@testable import TomatoCrypto

class OaepPaddingTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOaepPadding() {
        let mStr = "bbf82f090682ce9c2338ac2b9da871f7368d07eed41043a440d6b6f07454f51fb8dfbaaf035c02ab61ea48ceeb6fcd4876ed520d60e1ec4619719d8a5b8b807fafb8e0a3dfc737723ee6b4b7d93a2584ee6a649d060953748834b2454598394ee0aab12d7b61a51f527a9a41f6c1687fe2537298ca2a8f5946f8e5fd091dbdcb"
        let eStr = "11"
        let pStr = "eecfae81b1b9b3c908810b10a1b5600199eb9f44aef4fda493b81a9e3d84f632124ef0236e5d1e3b7e28fae7aa040a2d5b252176459d1f397541ba2a58fb6599"
        let qStr = "c97fb1f027f453f6341233eaaad1d9353f6c42d08866b1d05a0f2035028b9d869840b41666b42e92ea0da3b43204b5cfce3352524d0416a5a441e700af461503"
        let dpStr = "54494ca63eba0337e4e24023fcd69a5aeb07dddc0183a4d0ac9b54b051f2b13ed9490975eab77414ff59c1f7692e9a2e202b38fc910a474174adc93c1f67c981"
        let dqStr = "471e0290ff0af0750351b7f878864ca961adbd3a8a7e991c5c0556a94c3146a7f9803f8f6f8ae342e931fd8ae47a220d1b99a495849807fe39f9245a9836da3d"
        let qInvStr = "b06c4fdabb6301198d265bdbae9423b380f271f73453885093077fcd39e2119fc98632154f5883b167a967bf402b4e9e2e0f9656e698ea3666edfb25798039f7"

        let seed = hexToBytes(hex: "aafd12f659cae63489b479e5076ddec2f06cb58f")
        
        let plaintext = hexToBytes(hex: "d436e99569fd32a7c8a05bbc90d32c49")
        let ciphertext = hexToBytes(hex: "1253e04dc0a5397bb44a7ab87e9bf2a039a33d1e996fc82a94ccd30074c95df763722017069e5268da5d1c0b4f872cf653c11df82314a67968dfeae28def04bb6d84b1c31d654a1970e5783bd6eb96a024c2ca2f4a90fe9f2ef5c9c140e5bb48da9536ad8700c84fc9130adea74e558d51a74ddf85d8b50de96838d6063e0955")
        
        let mgfHash = MessageDigest(engine: Sha1Engine())
        let hash = MessageDigest(engine: Sha1Engine())
        let oaep = OaepPadding(engine: RsaEngine(), hash: hash, mgfHash: mgfHash)

        do {
            let publicKey = RsaPublicKeyParameter(modulusString: mStr, eString: eStr)
            let random = RandomParameter() { _, output in
                copyBytes(from: seed, fromOffset: 0, to: output, toOffset: 0, count: seed.count)
            }
            try oaep.initialize(isEncryption: true, parameters: [publicKey, random])
            let encrypted = try oaep.process(input: plaintext, count: plaintext.count)
            XCTAssertEqual(encrypted, ciphertext)

            let privateKey = RsaPrivateCrtKeyParameter(modulusString: mStr, pString: pStr, qString: qStr,
                                                       dpString: dpStr, dqString: dqStr, qInvString: qInvStr)
            try oaep.initialize(isEncryption: false, parameters: [privateKey])
            let decrypted = try oaep.process(input: encrypted, count: encrypted.count)
            XCTAssertEqual(decrypted, plaintext)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
