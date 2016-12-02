public class OfbMode: BlockCipherEngine {
    private let engine: BlockCipherEngine

    private let xorWordMode: Bool
    private let xorSize: Int

    public var blockSize: Int {
        return self.engine.blockSize
    }

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
        
        self.iv = ivParam.iv

        self.reset()
    }

    public func reset() {
        self.engine.reset()
        copyBytes(from: self.iv!, to: &self.feedback)
    }
    
    public func processBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        guard (input.count - inputOffset) >= self.blockSize else {
            throw CryptoError.illegalBlockSize("Block size must be \(self.blockSize * 8)-bit")
        }

        try self.engine.processBlock(input: self.feedback, inputOffset: 0, output: &self.feedback, outputOffset: 0)
        xor(input1: self.feedback, offset1: 0,
            input2: input, offset2: inputOffset,
            output: &output, offset: outputOffset,
            count: self.xorSize, wordMode: self.xorWordMode)
    }
}
