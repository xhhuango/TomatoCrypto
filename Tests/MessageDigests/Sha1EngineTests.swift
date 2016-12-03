import XCTest
@testable import TomatoCrypto

class Sha1EngineTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDigest1() {
        let input = stringToBytes(string: "")
        let expected = hexToBytes(hex: "da39a3ee5e6b4b0d3255bfef95601890afd80709")

        let engine = Sha1Engine()
        engine.reset()
        let padding = engine.pad(input: input, count: input.count)
        engine.digestBlock(input: padding)
        var output = [Byte](repeating: 0, count: engine.outputSize)
        engine.output(output: &output)
        XCTAssertEqual(output, expected)
    }

    func testDigest2() {
        let input = stringToBytes(string: "a")
        let expected = hexToBytes(hex: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")

        let engine = Sha1Engine()
        engine.reset()
        let padding = engine.pad(input: input, count: input.count)
        engine.digestBlock(input: padding)
        var output = [Byte](repeating: 0, count: engine.outputSize)
        engine.output(output: &output)
        XCTAssertEqual(output, expected)
    }

    func testDigest3() {
        let input = stringToBytes(string: "abc")
        let expected = hexToBytes(hex: "a9993e364706816aba3e25717850c26c9cd0d89d")

        let engine = Sha1Engine()
        engine.reset()
        let padding = engine.pad(input: input, count: input.count)
        engine.digestBlock(input: padding)
        var output = [Byte](repeating: 0, count: engine.outputSize)
        engine.output(output: &output)
        XCTAssertEqual(output, expected)
    }
    
    func testDigest4() {
        let input = stringToBytes(string: "abcdefghijklmnopqrstuvwxyz")
        let expected = hexToBytes(hex: "32d10c7b8cf96570ca04ce37f2a19d84240d3a89")

        let engine = Sha1Engine()
        engine.reset()
        let padding = engine.pad(input: input, count: input.count)
        engine.digestBlock(input: padding)
        var output = [Byte](repeating: 0, count: engine.outputSize)
        engine.output(output: &output)
        XCTAssertEqual(output, expected)
    }
    
    func testDigest5() {
        let input = stringToBytes(string: "abcdefghijklmnopqrstuvwxyz")
        let expected = hexToBytes(hex: "32d10c7b8cf96570ca04ce37f2a19d84240d3a89")

        let engine = Sha1Engine()
        engine.reset()
        let padding = engine.pad(input: input, count: input.count)
        engine.digestBlock(input: padding)
        var output = [Byte](repeating: 0, count: engine.outputSize)
        engine.output(output: &output)
        XCTAssertEqual(output, expected)
    }
}
