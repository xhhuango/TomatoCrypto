public class Pkcs7Padding: BlockCipherPadding {
    public func add(input: inout [Byte], offset: Int) -> Int {
        let value = input.count - offset
        memset(&input[offset], Int32(value), value)
        return value
    }
    
    public func padCount(input: [Byte]) -> Int {
        return Int(input[input.count - 1])
    }
}
