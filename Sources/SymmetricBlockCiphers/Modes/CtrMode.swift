public class CtrMode: SymmetricBlockCipherEngine {
    private let engine: SymmetricBlockCipherEngine
    
    private let xorWordMode: Bool
    private let xorSize: Int
    
    public var blockSize: Int {
        return self.engine.blockSize
    }

    private var iv: [Byte]!

    private var counter: [Byte]

    public init(engine: SymmetricBlockCipherEngine) {
        self.engine = engine

        self.xorWordMode = (engine.blockSize % wordSize == 0)
        self.xorSize = self.xorWordMode ? engine.blockSize / wordSize : engine.blockSize

        self.counter = [Byte](repeating: 0, count: engine.blockSize)
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
        copyBytes(from: self.iv!, to: &self.counter)
    }
    
    public func processBlock(input: [Byte], inputOffset: Int, output: inout [Byte], outputOffset: Int) throws {
        guard (input.count - inputOffset) >= self.blockSize else {
            throw CryptoError.illegalBlockSize("Block size must be \(self.blockSize * 8)-bit")
        }

        try self.engine.processBlock(input: self.counter, inputOffset: 0, output: &output, outputOffset: outputOffset)
        xor(input1: output, offset1: outputOffset,
            input2: input, offset2: inputOffset,
            output: &output, offset: outputOffset,
            count: xorSize, wordMode: xorWordMode)

        let counterIndex = self.counter.count - 1
        if self.counter[counterIndex] == 0xFF {
            for i in (0...counterIndex).reversed() {
                if self.counter[i] != 0xFF {
                    self.counter[i] += 1
                    break
                } else {
                    self.counter[i] = 0
                }
            }
        } else {
            self.counter[counterIndex] += 1
        }
    }
}
