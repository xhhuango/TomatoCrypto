public class AsymmetricCipher {
    private let engine: AsymmetricCipherEngine
    
    private var isEncryption = true
    
    public var inputSize: Int {
        return self.engine.inputSize
    }
    
    public var outputSize: Int {
        return self.engine.outputSize
    }
    
    public init(engine: AsymmetricCipherEngine) {
        self.engine = engine
    }

    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)
        self.isEncryption = isEncryption
    }
    
    public func process(input: UnsafePointer<Byte>, count: Int) throws -> [Byte] {
        return try self.engine.process(input: input, count: count)
    }

    public func process(input: [Byte]) throws -> [Byte] {
        return try self.process(input: input, count: input.count)
    }
}
