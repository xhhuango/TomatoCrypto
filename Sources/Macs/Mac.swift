public class Mac {
    private let engine: MacEngine

    public var outputSize: Int {
        return self.engine.outputSize
    }

    public init(engine: MacEngine) {
        self.engine = engine
    }

    public func reset() {
        self.engine.reset()
    }

    @discardableResult
    public func initialize(parameters: [CryptoParameter]) throws -> Mac {
        try self.engine.initialize(parameters: parameters)
        return self
    }
    
    public func update(input: UnsafePointer<Byte>, count: Int) throws {
        try self.engine.update(input: input, count: count)
    }

    public func update(input: [Byte]) throws {
        try self.update(input: input, count: input.count)
    }
    
    public func finalize() throws -> [Byte] {
        let res = try self.engine.finalize()
        self.reset()
        return res
    }

    @discardableResult
    public func finalize(output: UnsafeMutablePointer<Byte>) throws -> Int {
        let mac = try self.finalize()
        copyBytes(from: mac, to: output, count: mac.count)
        return mac.count
    }
}
