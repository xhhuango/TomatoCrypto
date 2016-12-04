public class BlockCipher {
    private let engine: BlockCipherEngine
    private let padding: BlockCipherPadding
    
    private var isEncryption = true

    public var blockSize: Int {
        return self.engine.blockSize
    }
    
    public init(engine: BlockCipherEngine, padding: BlockCipherPadding = NoPadding()) {
        self.engine = engine
        self.padding = padding
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)
        self.isEncryption = isEncryption
    }

    public func process(input: [Byte]) throws -> [Byte] {
        self.engine.reset()

        let blockSize = self.engine.blockSize

        if isEncryption {
            let padCount = blockSize - (input.count % blockSize)
            let paddedInput = self.padding.add(input: input, count: padCount)
            var output = [Byte](repeating: 0, count: paddedInput.count)
            
            for i in 0..<(input.count / blockSize) {
                let offset = blockSize * i
                try self.engine.processBlock(input: paddedInput, inputOffset: offset,
                                             output: &output, outputOffset: offset)
            }
            
            return output
        } else {
            guard input.count % blockSize == 0 else {
                throw CryptoError.illegalBlockSize("Input length must be multiple of \(blockSize) bytes")
            }

            var paddedOutput = [Byte](repeating: 0, count: input.count)

            for i in 0..<(input.count / blockSize) {
                let offset = blockSize * i
                try self.engine.processBlock(input: input, inputOffset: offset,
                                             output: &paddedOutput, outputOffset: offset)
            }

            return self.padding.remove(input: paddedOutput)
        }
    }
}
