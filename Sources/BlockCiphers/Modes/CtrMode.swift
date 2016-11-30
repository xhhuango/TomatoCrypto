public class CtrMode: BlockCipherMode {
    private var engine: BlockCipherEngine!
    private var iv: [Byte]!
    
    public func initialize(processMode: BlockCipher.ProcessMode,
                           engine: BlockCipherEngine,
                           key: SecretKey,
                           parameters: [BlockCipherParameter]) throws {
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
        
        try engine.initialize(processMode: .encryption, key: key)
        self.engine = engine
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let engine = self.engine else {
            throw CryptoError.cipherNotInitialize("\(self) is not initialized")
        }
        guard input.count % engine.blockSize == 0 else {
            throw CryptoError.illegalBlockSize("Input length must be multiple of \(engine.blockSize) bytes")
        }
        
        let blockSize = self.engine.blockSize
        let xorWordMode = input.count % blockSize == 0
        let xorSize = xorWordMode ? input.count / blockSize : blockSize
        
        var iv = self.iv!
        let counterIndex = iv.count - 1
        let counterIndexRange = (0...counterIndex).reversed()
        var output = [Byte](repeating: 0, count: input.count)
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            try self.engine.processBlock(input: iv, inputOffset: 0, output: &output, outputOffset: from)
            xor(input1: output, offset1: from,
                input2: input, offset2: from,
                output: &output, offset: from,
                count: xorSize, wordMode: xorWordMode)
            
            if iv[counterIndex] == 0xFF {
                for i in counterIndexRange {
                    if iv[i] != 0xFF {
                        iv[i] += 1
                        break
                    } else {
                        iv[i] = 0
                    }
                }
            } else {
                iv[counterIndex] += 1
            }
        }
        
        return output
    }
}
