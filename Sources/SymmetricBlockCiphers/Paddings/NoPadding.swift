public class NoPadding: SymmetricBlockCipherPadding {
    public func add(input: [Byte], count: Int) -> [Byte] {
        return input
    }
    
    public func remove(input: [Byte]) -> [Byte] {
        return input
    }
}
