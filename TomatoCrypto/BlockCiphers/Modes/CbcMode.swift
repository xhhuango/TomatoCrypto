public class CbcMode: BlockCipherMode {
    private var processMode: BlockCipher.ProcessMode!
    private var engine: BlockCipherEngine!
    private var iv: [Byte]!
    
    public func initialize(processMode: BlockCipher.ProcessMode,
                           engine: BlockCipherEngine,
                           key: SecretKey,
                           parameters: [BlockCipherParameter]) throws {
        self.processMode = processMode
        
        var iv: IvParameter!
        for param in parameters {
            if param is IvParameter {
                iv = param as! IvParameter
            }
        }
        guard iv != nil else {
            throw CryptoError.missingParameter("IV is missing")
        }
        self.iv = iv.bytes
        guard self.iv.count == engine.blockSize else {
            throw CryptoError.invalidParameter("IV must be \(engine.blockSize)-byte")
        }
        
        try engine.initialize(processMode: processMode, key: key)
        self.engine = engine
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let engine = self.engine, let processMode = self.processMode else {
            throw CryptoError.cipherNotInitialize("\(self) is not initialized")
        }
        guard input.count % engine.blockSize == 0 else {
            throw CryptoError.illegalBlockSize("Input length must be multiple of \(engine.blockSize) bytes")
        }
        
        switch processMode {
        case .encryption:
            return try self.encrypt(input: input, iv: self.iv)
        case .decryption:
            return try self.decrypt(input: input, iv: self.iv)
        }
    }
    
    private func encrypt(input: [Byte], iv: [Byte]) throws -> [Byte] {
        let blockSize = self.engine.blockSize
        let xorWordMode = input.count % blockSize == 0
        let xorSize = xorWordMode ? input.count / blockSize : blockSize
        var feedbackIndex = -1
        var output = [Byte](repeating: 0, count: input.count)
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            if from != 0 {
                xor(input1: input, offset1: from,
                    input2: output, offset2: feedbackIndex,
                    output: &output, offset: from,
                    count: xorSize, wordMode: xorWordMode)
                feedbackIndex = from
            } else {
                xor(input1: input, offset1: 0,
                    input2: iv, offset2: 0,
                    output: &output, offset: 0,
                    count: xorSize, wordMode: xorWordMode)
                feedbackIndex = 0
            }
            try self.engine.processBlock(input: output, inputOffset: from, output: &output, outputOffset: from)
        }
        
        return output
    }
    
    private func decrypt(input: [Byte], iv: [Byte]) throws -> [Byte] {
        let blockSize = self.engine.blockSize
        let xorWordMode = input.count % blockSize == 0
        let xorSize = xorWordMode ? input.count / blockSize : blockSize
        
        var feedbackIndex = -1
        var output = [Byte](repeating: 0, count: input.count)
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            try self.engine.processBlock(input: input, inputOffset: from, output: &output, outputOffset: from)
            if from != 0 {
                xor(input1: output, offset1: from,
                    input2: input, offset2: feedbackIndex,
                    output: &output, offset: from,
                    count: xorSize, wordMode: xorWordMode)
                feedbackIndex = from
            } else {
                xor(input1: output, offset1: 0,
                    input2: iv, offset2: 0,
                    output: &output, offset: 0,
                    count: xorSize, wordMode: xorWordMode)
                feedbackIndex = 0
            }
        }
        
        return output
    }
}
