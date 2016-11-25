import Foundation

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
            throw CryptoError.cipherNotInitialize("\(#file) is not initialized")
        }
        guard input.count % engine.blockSize == 0 else {
            throw CryptoError.illegalBlockSize("Input length must be multiple of \(engine.blockSize) bytes")
        }
        
        let blockSize = self.engine.blockSize
        var iv = self.iv!
        let counterIndex = iv.count - 1
        var output: [Byte] = []
        
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            let to = from + blockSize
            let block = [Byte](input[from..<to])
            
            let encrypted = try self.engine.processBlock(input: iv)
            output += xorBytes(bytes1: encrypted, bytes2: block)
            
            if iv[counterIndex] == 0xFF {
                for i in (0...counterIndex).reversed() {
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
