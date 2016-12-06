public class Signature {
    private let engine: SignatureEngine
    private var isSigning: Bool = true

    public init(engine: SignatureEngine) {
        self.engine = engine
    }
    
    public func initialize(isSigning: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isSigning: isSigning, parameters: parameters)
        self.isSigning = isSigning
    }
    
    public func reset() {
        self.engine.reset()
    }
    
    public func update(input: UnsafePointer<Byte>, count: Int) {
        self.engine.update(input: input, count: count)
    }

    public func update(input: [Byte]) {
        self.update(input: input, count: input.count)
    }
    
    public func sign() throws -> [Byte] {
        guard self.isSigning else {
            throw CryptoError.wrongMode("Need to be initialied to signing mode")
        }
        
        let sig = try self.engine.sign()
        self.reset()
        return sig
    }

    @discardableResult
    public func sign(output: UnsafeMutablePointer<Byte>) throws -> Int {
        let sig = try self.sign()
        copyBytes(from: sig, to: output, count: sig.count)
        return sig.count
    }
    
    public func verify(signature: UnsafePointer<Byte>, count: Int) throws -> Bool {
        guard !self.isSigning else {
            throw CryptoError.wrongMode("Need to be signature to verifying mode")
        }

        let res = try self.engine.verify(signature: signature, count: count)
        self.reset()
        return res
    }

    public func verify(signature: [Byte]) throws -> Bool {
        return try self.verify(signature: signature, count: signature.count)
    }
}
