public class EcbMode: BlockCipherEngine {
    private let engine: BlockCipherEngine

    public var blockSize: Int {
        return self.engine.blockSize
    }

    public init(engine: BlockCipherEngine) {
        self.engine = engine
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)
    }

    public func reset() {
        self.engine.reset()
    }

    public func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.engine.processBlock(input: input, output: output)
    }
}
