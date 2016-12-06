import XCTest
@testable import TomatoCrypto
import BigInt

class RsaPssSignerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSig() {
        let mStr = "bcb47b2e0dafcba81ff2a2b5cb115ca7e757184c9d72bcdcda707a146b3b4e29989ddc660bd694865b932b71ca24a335cf4d339c719183e6222e4c9ea6875acd528a49ba21863fe08147c3a47e41990b51a03f77d22137f8d74c43a5a45f4e9e18a2d15db051dc89385db9cf8374b63a8cc88113710e6d8179075b7dc79ee76b"
        let eStr = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001"
        let dStr = "383a6f19e1ea27fd08c7fbc3bfa684bd6329888c0bbe4c98625e7181f411cfd0853144a3039404dda41bce2e31d588ec57c0e148146f0fa65b39008ba5835f829ba35ae2f155d61b8a12581b99c927fd2f22252c5e73cba4a610db3973e019ee0f95130d4319ed413432f2e5e20d5215cdd27c2164206b3f80edee51938a25c1"
        let saltStr = "6f2841166a64471d4f0b8ed0dbb7db32161da13b"
        let msgStr = "1248f62a4389f42f7b4bb131053d6c88a994db2075b912ccbe3ea7dc611714f14e075c104858f2f6e6cfd6abdedf015a821d03608bf4eba3169a6725ec422cd9069498b5515a9608ae7cc30e3d2ecfc1db6825f3e996ce9a5092926bc1cf61aa42d7f240e6f7aa0edb38bf81aa929d66bb5d890018088458720d72d569247b0c"
        let sigStr = "682cf53c1145d22a50caa9eb1a9ba70670c5915e0fdfde6457a765de2a8fe12de9794172a78d14e668d498acedad616504bb1764d094607070080592c3a69c343d982bd77865873d35e24822caf43443cc10249af6a1e26ef344f28b9ef6f14e09ad839748e5148bcceb0fd2aa63709cb48975cbf9c7b49abc66a1dc6cb5b31a"

        let m = BigUInt(mStr, radix: 16)!
        let d = BigUInt(dStr, radix: 16)!
        let e = BigUInt(eStr, radix: 16)!
        let msg = hexToBytes(hex: msgStr)
        let sig = hexToBytes(hex: sigStr)
        let privateKey = RsaPrivateKeyParameter(modulus: m, d: d)
        let publicKey = RsaPublicKeyParameter(modulus: m, e: e)
        let salt = SaltParameter(salt: hexToBytes(hex: saltStr))

        let cipher = AsymmetricCipher(engine: RsaEngine())
        let hash = MessageDigest(engine: Sha1Engine())
        let mgfHash = MessageDigest(engine: Sha1Engine())
        
        let signer = RsaPssSigner(cipher: cipher, hash: hash, mgfHash: mgfHash)

        do {
            try signer.initialize(isSigning: true, parameters: [privateKey, salt])
            signer.update(input: msg, count: msg.count)
            let signature = try signer.sign()
            XCTAssertEqual(signature, sig)

            signer.reset()

            try signer.initialize(isSigning: false, parameters: [publicKey, salt])
            signer.update(input: msg, count: msg.count)
            let verified = try signer.verify(signature: signature, count: signature.count)
            XCTAssertTrue(verified)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
