import XCTest
@testable import TomatoCrypto

class HmacEngineTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHmac() {
        let key = hexToBytes(hex: "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
        let msg = stringToBytes(string: "Hi There")
        let expected = hexToBytes(hex: "b617318655057264e28bc0b6fb378c8ef146be00")

        let hash = MessageDigest(engine: Sha1Engine())
        let engine = HmacEngine(hash: hash)
        let keyParam = SimpleSecretKeyParameter(key: key)

        do {
            try engine.initialize(parameters: [keyParam])
            try engine.update(input: msg, count: msg.count)
            let mac = try engine.finalize()
            XCTAssertEqual(mac, expected)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
