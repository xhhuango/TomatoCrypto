import XCTest
@testable import TomatoCrypto

class MessageDigestTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMessageDigest1() {
        let input1 = stringToBytes(string: "")
        let expected1 = hexToBytes(hex: "da39a3ee5e6b4b0d3255bfef95601890afd80709")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input1), expected1)
    }

    func testMessageDigest2() {
        let input2 = stringToBytes(string: "a")
        let expected2 = hexToBytes(hex: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input2), expected2)
    }

    func testMessageDigest3() {
        let input3 = stringToBytes(string: "abc")
        let expected3 = hexToBytes(hex: "a9993e364706816aba3e25717850c26c9cd0d89d")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input3), expected3)
    }

    func testMessageDigest4() {
        let input4 = [Byte](repeating: 0, count: 60)
        let expected4 = hexToBytes(hex: "FB3D8FB74570A077E332993F7D3D27603501B987")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input4), expected4)
    }

    func testMessageDigest5() {
        let input5 = [Byte](repeating: 0, count: 64)
        let expected5 = hexToBytes(hex: "C8D7D0EF0EEDFA82D2EA1AA592845B9A6D4B02B7")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input5), expected5)
    }

    func testMessageDigest6() {
        let input6 = [Byte](repeating: 0, count: 70)
        let expected6 = hexToBytes(hex: "3CC4A1CC99309A6512D22CF3CD62537F971893AB")
        let digest = MessageDigest(engine: Sha1Engine())
        XCTAssertEqual(digest.finalize(input: input6), expected6)
    }
}
