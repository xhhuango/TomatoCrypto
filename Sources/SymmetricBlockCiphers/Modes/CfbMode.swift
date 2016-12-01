public class CfbMode: SymmetricBlockCipherEngine {
    private let engine: SymmetricBlockCipherEngine

    private let xorWordMode: Bool
    private let xorSize: Int
    
    public var blockSize: Int {
        return self.engine.blockSize
    }

    private var isEncryption = true
    private var iv: [Byte]!

    private var feedback: [Byte]

    public init(engine: SymmetricBlockCipherEngine) {
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

    public func processBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        guard (input.count - inputOffset) >= self.blockSize else {
            throw CryptoError.illegalBlockSize("Block size must be \(self.blockSize * 8)-bit")
        }

        if self.isEncryption {
            try self.encryptBlock(input: input, inputOffset: inputOffset, output: &output, outputOffset: outputOffset)
        } else {
            try self.decryptBlock(input: input, inputOffset: inputOffset, output: &output, outputOffset: outputOffset)
        }
    }

    public func encryptBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        try self.engine.processBlock(input: self.feedback, inputOffset: 0, output: &output, outputOffset: outputOffset)
        xor(input1: output, offset1: outputOffset,
            input2: input, offset2: inputOffset,
            output: &output, offset: outputOffset,
            count: xorSize, wordMode: xorWordMode)
        copyBytes(from: output, fromOffset: outputOffset, to: &self.feedback, toOffset: 0, count: self.feedback.count)
    }

    public func decryptBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        try self.engine.processBlock(input: self.feedback, inputOffset: 0, output: &output, outputOffset: outputOffset)
        copyBytes(from: input, fromOffset: inputOffset, to: &self.feedback, toOffset: 0, count: self.feedback.count)
        xor(input1: output, offset1: outputOffset,
            input2: feedback, offset2: 0,
            output: &output, offset: outputOffset,
            count: xorSize, wordMode: xorWordMode)
    }
}
