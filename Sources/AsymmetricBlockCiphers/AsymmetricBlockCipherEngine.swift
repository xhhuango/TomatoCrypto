public protocol AsymmetricBlockCipherEngine {
    var inputBlockSize: Int { get }
    
    func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws
    func processBlock(input: [Byte], offset: Int, length: Int) throws -> [Byte]
}
