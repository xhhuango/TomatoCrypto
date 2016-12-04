public class BlockCipher {
    private let engine: BlockCipherEngine
    private let padding: BlockCipherPadding
    
    private var isEncryption = true
    
    private var buffer: [Byte]
    private var bufferIndex = 0

    public var blockSize: Int {
        return self.engine.blockSize
    }
    
    public init(engine: BlockCipherEngine, padding: BlockCipherPadding) {
        self.engine = engine
        self.padding = padding
        self.buffer = [Byte](repeating: 0, count: engine.blockSize)
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)
        self.isEncryption = isEncryption
        self.reset()
    }

    public func reset() {
        self.engine.reset()
        self.bufferIndex = 0
    }

    private func encrypt(input: UnsafePointer<Byte>, inputCount: Int,
                         output: UnsafeMutablePointer<Byte>, isFinal: Bool) throws -> Int {
        var outputOffset = 0
        var remaining = inputCount
        while remaining > 0 {
            let countEmpty = self.buffer.count - bufferIndex
            if remaining >= countEmpty {
                copyBytes(from: input, fromOffset: inputCount - remaining,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: countEmpty)
                remaining -= countEmpty
                bufferIndex = 0
                try self.engine.processBlock(input: self.buffer, output: output.advanced(by: outputOffset))
                outputOffset += self.buffer.count
            } else {
                copyBytes(from: input, fromOffset: inputCount - remaining,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: remaining)
                bufferIndex += remaining
                remaining = 0
            }
        }

        if isFinal && self.bufferIndex != 0 {
            let padded = self.padding.add(input: self.buffer, count: self.bufferIndex)
            self.bufferIndex = 0
            outputOffset += try self.encrypt(input: padded, inputCount: padded.count,
                                             output: output.advanced(by: outputOffset), isFinal: false)
        }

        return outputOffset
    }

    private func decrypt(input: UnsafePointer<Byte>, inputCount: Int,
                         output: UnsafeMutablePointer<Byte>, isFinal: Bool) throws -> Int {

        var outputOffset = 0
        var remaining = inputCount
        while remaining > 0 {
            let countEmpty = self.buffer.count - bufferIndex
            if remaining >= countEmpty {
                copyBytes(from: input, fromOffset: inputCount - remaining,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: countEmpty)
                remaining -= countEmpty
                bufferIndex = 0
                if remaining == 0 && isFinal {
                    var padded = [Byte](repeating: 0, count: self.buffer.count)
                    try self.engine.processBlock(input: self.buffer, output: &padded)
                    let unpadded = self.padding.remove(input: padded)
                    copyBytes(from: unpadded, fromOffset: 0, to: output, toOffset: outputOffset, count: unpadded.count)
                    outputOffset += unpadded.count
                } else {
                    try self.engine.processBlock(input: self.buffer, output: output.advanced(by: outputOffset))
                    outputOffset += self.buffer.count
                }
            } else {
                if isFinal {
                    throw CryptoError.invalidCipherText("Data wrong")
                } else {
                    copyBytes(from: input, fromOffset: inputCount - remaining,
                              to: &self.buffer, toOffset: bufferIndex,
                              count: remaining)
                    bufferIndex += remaining
                    remaining = 0
                }
            }
        }

        return outputOffset
    }

    private func process(input: UnsafePointer<Byte>, inputCount: Int,
                         output: UnsafeMutablePointer<Byte>, isFinal: Bool) throws -> Int {
        return self.isEncryption
            ? try self.encrypt(input: input, inputCount: inputCount, output: output, isFinal: isFinal)
            : try self.decrypt(input: input, inputCount: inputCount, output: output, isFinal: isFinal)
    }

    @discardableResult
    public func update(input: UnsafePointer<Byte>, count: Int, output: UnsafeMutablePointer<Byte>) throws -> Int {
        return try self.process(input: input, inputCount: count, output: output, isFinal: false)
    }

    public func update(input: [Byte]) throws -> [Byte] {
        let outputCount = ((input.count + self.bufferIndex - 1) / self.blockSize) * self.blockSize
        var output = [Byte](repeating: 0, count: outputCount)
        try self.update(input: input, count: input.count, output: &output)
        return output
    }

    @discardableResult
    public func finalize(input: UnsafePointer<Byte>, count: Int, output: UnsafeMutablePointer<Byte>) throws -> Int {
        let processed = try self.process(input: input, inputCount: count, output: output, isFinal: true)
        self.reset()
        return processed
    }

    public func finalize(input: [Byte]) throws -> [Byte] {
        let outputCount = ((input.count + self.bufferIndex - 1) / self.blockSize + 1) * self.blockSize
        var output = [Byte](repeating: 0, count: outputCount)
        try self.finalize(input: input, count: input.count, output: &output)
        return output
    }

//    public func process(input: UnsafePointer<Byte>, inputCount: Int,
//                        output: UnsafeMutablePointer<Byte>, outputCount: Int) throws {
//        self.engine.reset()
//
//        let blockSize = self.engine.blockSize
//
//        if isEncryption {
//            let padCount = blockSize - (input.count % blockSize)
//            let paddedInput = self.padding.add(input: input, count: padCount)
//            var output = [Byte](repeating: 0, count: paddedInput.count)
//            
//            for i in 0..<(input.count / blockSize) {
//                let offset = blockSize * i
//                try self.engine.processBlock(input: paddedInput, inputOffset: offset,
//                                             output: &output, outputOffset: offset)
//            }
//            
//            return output
//        } else {
//            guard input.count % blockSize == 0 else {
//                throw CryptoError.illegalBlockSize("Input length must be multiple of \(blockSize) bytes")
//            }
//
//            var paddedOutput = [Byte](repeating: 0, count: input.count)
//
//            for i in 0..<(input.count / blockSize) {
//                let offset = blockSize * i
//                try self.engine.processBlock(input: input, inputOffset: offset,
//                                             output: &paddedOutput, outputOffset: offset)
//            }
//
//            return self.padding.remove(input: paddedOutput)
//        }
//    }
}
