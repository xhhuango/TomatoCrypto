public class OfbMode: BlockCipherEngine {
    private let engine: BlockCipherEngine

    public var blockSize: Int {
        return self.engine.blockSize
    }

    private var iv: [Byte]!

    private var feedback: [Byte]

    public init(engine: BlockCipherEngine) {
        self.engine = engine
        self.feedback = [Byte](repeating: 0, count: engine.blockSize)
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        guard let ivParam: IvParameter = findParameter(within: parameters) else {
            throw CryptoError.missingParameter("\(self) expects \(IvParameter.self)")
        }
        guard ivParam.iv.count == self.blockSize else {
            throw CryptoError.invalidParameter("IV must be \(self.blockSize)-byte")
        }

        try self.engine.initialize(isEncryption: true, parameters: parameters)
        
        self.iv = ivParam.iv

        self.reset()
    }

    public func reset() {
        self.engine.reset()
        copyBytes(from: self.iv!, to: &self.feedback)
    }
    
    public func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.engine.processBlock(input: self.feedback, output: &self.feedback)
        xorBytes(input1: self.feedback, input2: input, output: output, count: self.blockSize)
    }
}
