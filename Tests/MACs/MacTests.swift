import XCTest
@testable import TomatoCrypto

class MacTests: XCTestCase {
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
        let mac = Mac(engine: engine)
        let keyParam = SimpleSecretKeyParameter(key: key)

        do {
            try mac.initialize(parameters: [keyParam])
            try mac.update(input: msg)
            let res = try mac.finalize()
            XCTAssertEqual(res, expected)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
