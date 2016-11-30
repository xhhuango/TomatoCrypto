public protocol AsymmetricBlockCipherEngine {
    var inputBlockSize: Int { get }
    
    func initialize(key: Key) throws
    func processBlock(input: [Byte], offset: Int, length: Int) throws -> [Byte]
}
