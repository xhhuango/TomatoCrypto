public class Signature {
    private let engine: SignatureEngine

    public init(engine: SignatureEngine) {
        self.engine = engine
    }
    
    public func initialize(isSigning: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isSigning: isSigning, parameters: parameters)
    }
    
    public func update(input: UnsafePointer<Byte>, count: Int) {
        self.engine.update(input: input, count: count)
    }
    
    public func sign() throws -> [Byte] {
        let sig = try self.engine.sign()
        self.engine.reset()
        return sig
    }
    
    public func verify(signature: UnsafePointer<Byte>, count: Int) throws -> Bool {
        let res = try self.engine.verify(signature: signature, count: count)
        self.engine.reset()
        return res
    }
}
