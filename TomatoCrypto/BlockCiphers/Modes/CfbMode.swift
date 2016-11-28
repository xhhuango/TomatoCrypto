import Foundation

public class CfbMode: BlockCipherMode {
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
        
        try engine.initialize(processMode: .encryption, key: key)
        self.engine = engine
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let engine = self.engine, let processMode = self.processMode else {
            throw CryptoError.cipherNotInitialize("\(#file) is not initialized")
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
    
    public func encrypt(input: [Byte], iv: [Byte]) throws -> [Byte] {
        let blockSize = self.engine.blockSize
        let xorWordMode = input.count % blockSize == 0
        let xorSize = xorWordMode ? input.count / blockSize : blockSize
        
        var feedback = iv
        var output = [Byte](repeating: 0, count: input.count)
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            try self.engine.processBlock(input: feedback, inputOffset: 0, output: &output, outputOffset: from)
            xor(input1: output, offset1: from,
                input2: input, offset2: from,
                output: &output, offset: from,
                count: xorSize, wordMode: xorWordMode)
            copyBytes(from: output, fromOffset: from, to: &feedback, toOffset: 0, count: blockSize)
        }
        
        return output
    }
    
    public func decrypt(input: [Byte], iv: [Byte]) throws -> [Byte] {
        let blockSize = self.engine.blockSize
        let xorWordMode = input.count % blockSize == 0
        let xorSize = xorWordMode ? input.count / blockSize : blockSize
        
        var feedback = iv
        var output = [Byte](repeating: 0, count: input.count)
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            try self.engine.processBlock(input: feedback, inputOffset: 0, output: &output, outputOffset: from)
            copyBytes(from: input, fromOffset: from, to: &feedback, toOffset: 0, count: blockSize)
            xor(input1: output, offset1: from,
                input2: feedback, offset2: 0,
                output: &output, offset: from,
                count: xorSize, wordMode: xorWordMode)
        }
        
        return output
    }
}
