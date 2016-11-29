import XCTest
@testable import TomatoCrypto

class StringTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBytesToHex() {
        let bytes: [UInt8] = [0xFF, 0xAA, 0x77, 0x66]
        let hex = "FFAA7766"
        XCTAssertEqual(bytesToHex(bytes: bytes), hex)
    }
    
    func testHexToBytes() {
        let hex = "123456ABCD"
        let bytes: [UInt8] = [0x12, 0x34, 0x56, 0xAB, 0xCD]
        XCTAssertEqual(hexToBytes(hex: hex), bytes)
    }
}
