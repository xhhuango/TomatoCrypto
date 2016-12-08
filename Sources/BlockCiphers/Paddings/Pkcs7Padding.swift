public class Pkcs7Padding: BlockCipherPadding {
    public func add(input: inout [Byte], offset: Int) -> Int {
        let value = input.count - offset
        fillBytes(byte: Byte(value), to: &input, offset: offset, count: value)
        return value
    }
    
    public func padCount(input: [Byte]) -> Int {
        return Int(input[input.count - 1])
    }
}
