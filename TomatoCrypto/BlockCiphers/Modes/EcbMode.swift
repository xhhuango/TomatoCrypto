public class EcbMode: BlockCipherMode {
    private var engine: BlockCipherEngine!
    
    public func initialize(processMode: BlockCipher.ProcessMode,
                           engine: BlockCipherEngine,
                           key: SecretKey,
                           parameters: [BlockCipherParameter]) throws {
        try engine.initialize(processMode: processMode, key: key)
        self.engine = engine
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let engine = self.engine else {
            throw CryptoError.cipherNotInitialize("\(self) is not initialized")
        }
        
        let blockSize = engine.blockSize
        guard input.count % blockSize == 0 else {
            throw CryptoError.illegalBlockSize("Input length must be multiple of \(blockSize) bytes")
        }
        
        var output = [Byte](repeating: 0, count: input.count)
        for i in 0..<(input.count / blockSize) {
            let offset = blockSize * i
            try self.engine.processBlock(input: input, inputOffset: offset, output: &output, outputOffset: offset)
        }
        return output
    }
}
