import Foundation

public class BlockCipher {
    public enum ProcessMode {
        case encryption
        case decryption
    }
    
    private let engine: BlockCipherEngine
    private let mode: BlockCipherMode
    private let padding: BlockCipherPadding
    
    private var processMode: ProcessMode!
    
    public init(engine: BlockCipherEngine, mode: BlockCipherMode, padding: BlockCipherPadding) {
        self.engine = engine
        self.mode = mode
        self.padding = padding
    }
    
    public func initialize(processMode: ProcessMode, key: SecretKey, parameters: [BlockCipherParameter] = []) throws {
        self.processMode = processMode
        try self.mode.initialize(processMode: processMode,
                                 engine: self.engine,
                                 key: key,
                                 parameters: parameters)
    }
    
    public func process(input: [Byte]) throws -> [Byte] {
        guard let processMode = self.processMode else {
            throw CryptoError.cipherNotInitialize("\(#file) is not intailized")
        }
        
        switch processMode {
        case .encryption:
            let padCount = self.engine.blockSize - (input.count % self.engine.blockSize)
            return try self.mode.process(input: self.padding.add(input: input, cout: padCount))
            
        case .decryption:
            let output = try self.mode.process(input: input)
            return self.padding.remove(input: output)
        }
    }
}

