import Foundation

public class EcbMode: BlockCipherMode {
    private var engine: BlockCipherEngine!
    
    public func initialize(processMode: BlockCipher.ProcessMode, engine: BlockCipherEngine) {
        self.engine = engine
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let engine = self.engine else {
            throw CryptoError.cipherNotInitialize("\(#file) is not initialized")
        }
        
        let blockSize = engine.blockSize
        guard input.count % blockSize == 0 else {
            throw CryptoError.illegalBlockSize("Input length must be multiple of \(blockSize) bytes")
        }
        
        var output: [Byte] = []
        for i in 0..<(input.count / blockSize) {
            let from = blockSize * i
            let to = from + blockSize
            let block = [Byte](input[from..<to])
            output += try self.engine.processBlock(input: block)
        }
        
        return output
    }
}
