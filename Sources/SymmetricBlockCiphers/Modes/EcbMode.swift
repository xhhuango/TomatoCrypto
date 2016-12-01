public class EcbMode: SymmetricBlockCipherEngine {
    private let engine: SymmetricBlockCipherEngine

    public var blockSize: Int {
        return self.engine.blockSize
    }

    public init(engine: SymmetricBlockCipherEngine) {
        self.engine = engine
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)
    }

    public func reset() {
        self.engine.reset()
    }
    
    public func processBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        guard (input.count - inputOffset) >= self.blockSize else {
            throw CryptoError.illegalBlockSize("Block size must be \(self.blockSize * 8)-bit")
        }
        
        try self.engine.processBlock(input: input, inputOffset: inputOffset,
                                     output: &output, outputOffset: outputOffset)
    }
}
