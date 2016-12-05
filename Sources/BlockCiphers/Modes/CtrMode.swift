public class CtrMode: BlockCipherEngine {
    private let engine: BlockCipherEngine
    
    public var blockSize: Int {
        return self.engine.blockSize
    }

    private var iv: [Byte]!

    private var counter: [Byte]

    public init(engine: BlockCipherEngine) {
        self.engine = engine
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

    public func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.engine.processBlock(input: self.counter, output: output)
        xorBytes(input1: output, input2: input, output: output, count: self.blockSize)

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
