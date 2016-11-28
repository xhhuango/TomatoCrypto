import XCTest
@testable import TomatoCrypto

class ArrayTests: XCTestCase {
    let bytes = [UInt8](repeating: 0xA5, count: 1024 * 1024 * 10)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testXorWords() {
        let xoredBytes = xorBytes(input1: self.bytes, input2: self.bytes, count: self.bytes.count)
        let xoredWords = xorWords(input1: self.bytes, input2: self.bytes, count: self.bytes.count / MemoryLayout<Word>.size)
        XCTAssertEqual(xoredWords, xoredBytes)
    }
    
    func testPerformanceXorWords() {
        self.measure {
            let _ = xorWords(input1: self.bytes, input2: self.bytes, count: self.bytes.count / MemoryLayout<Word>.size)
        }
    }
    
    func testPerformanceXorBytes() {
        self.measure {
            let _ = xorBytes(input1: self.bytes, input2: self.bytes, count: self.bytes.count)
        }
    }
    
    func testCopyBytes() {
        let from = hexToBytes(hex: "0123456789abcdef")
        var to = [Byte](repeating: 0, count: from.count)
        copyBytes(from: from, fromOffset: 0, to: &to, toOffset: 0, count: from.count)
        XCTAssertEqual(from, to)
    }
    
    func testLeftRotateWord() {
        var origin = hexToBytes(hex: "12345678")
        let expected = hexToBytes(hex: "34567812")
        
        leftRotateWord(input: &origin, shiftBits: 8)
        XCTAssertEqual(origin, expected)
    }
    
    func testRightRotateWord() {
        var origin = hexToBytes(hex: "12345678")
        let expected = hexToBytes(hex: "78123456")
        
        rightRotateWord(input: &origin, shiftBits: 8)
        XCTAssertEqual(origin, expected)
    }
}
