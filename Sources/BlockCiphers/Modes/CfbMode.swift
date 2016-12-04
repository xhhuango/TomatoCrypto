public class CfbMode: BlockCipherEngine {
    private let engine: BlockCipherEngine

    private let xorWordMode: Bool
    private let xorSize: Int
    
    public var blockSize: Int {
        return self.engine.blockSize
    }

    private var isEncryption = true
    private var iv: [Byte]!

    private var feedback: [Byte]

    public init(engine: BlockCipherEngine) {
        self.engine = engine

        self.xorWordMode = (engine.blockSize % wordSize == 0)
        self.xorSize = self.xorWordMode ? engine.blockSize / wordSize : engine.blockSize

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
        
        self.isEncryption = isEncryption
        self.iv = ivParam.iv

        self.reset()
    }
    
    public func reset() {
        self.engine.reset()
        copyBytes(from: self.iv!, to: &self.feedback)
    }

    public func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        if self.isEncryption {
            try self.encryptBlock(input: input, output: output)
        } else {
            try self.decryptBlock(input: input, output: output)
        }
    }

    public func encryptBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.engine.processBlock(input: self.feedback, output: output)
        xor(input1: output, input2: input, output: output, count: xorSize, wordMode: xorWordMode)
        copyBytes(from: output, fromOffset: 0, to: &self.feedback, toOffset: 0, count: self.feedback.count)
    }

    public func decryptBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.engine.processBlock(input: self.feedback, output: output)
        copyBytes(from: input, to: &self.feedback, count: self.feedback.count)
        xor(input1: output, input2: feedback, output: output, count: xorSize, wordMode: xorWordMode)
    }
}
