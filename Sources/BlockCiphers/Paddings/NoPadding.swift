public class NoPadding: BlockCipherPadding {
    public func add(input: inout [Byte], offset: Int) -> Int {
        return 0
    }
    
    public func padCount(input: [Byte]) -> Int {
        return 0
    }
}
