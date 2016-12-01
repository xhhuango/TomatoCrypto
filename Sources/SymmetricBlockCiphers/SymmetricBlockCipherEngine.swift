public protocol SymmetricBlockCipherEngine {
    var blockSize: Int { get }

    func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws
    func reset()
    func processBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws
}
