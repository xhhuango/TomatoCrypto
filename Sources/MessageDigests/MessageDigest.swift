public class MessageDigest {
    private let engine: MessageDigestEngine

    private var buffer: [Byte]
    private var bufferIndex = 0
    
    public var inputSize: Int {
        return self.engine.inputSize
    }
    
    public var outputSize: Int {
        return self.engine.outputSize
    }

    public init(engine: MessageDigestEngine) {
        self.engine = engine
        engine.reset()
        self.buffer = [Byte](repeating: 0, count: engine.inputSize)
    }

    public func reset() {
        self.engine.reset()
        self.bufferIndex = 0
    }

    private func digest(input: UnsafePointer<Byte>, count: Int, isFinal: Bool) {
        var remaining = count
        while remaining > 0 {
            let countEmpty = buffer.count - bufferIndex
            if remaining >= countEmpty {
                copyBytes(from: input, fromOffset: count - remaining,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: countEmpty)
                remaining -= countEmpty
                bufferIndex = 0
                self.engine.digestBlock(input: self.buffer)
            } else {
                copyBytes(from: input, fromOffset: count - remaining,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: remaining)
                bufferIndex += remaining
                remaining = 0
            }
        }

        if isFinal {
            let padded = self.engine.pad(input: self.buffer, count: bufferIndex)
            bufferIndex = 0
            self.digest(input: padded, count: padded.count, isFinal: false)
        }
    }

    public func update(input: UnsafePointer<Byte>, count: Int) {
        self.digest(input: input, count: count, isFinal: false)
    }

    public func digest(input: UnsafePointer<Byte>, inputCount: Int, output: UnsafeMutablePointer<Byte>, outputOffset: Int) {
        self.digest(input: input, count: inputCount, isFinal: true)
        self.engine.output(output: output.advanced(by: outputOffset))
        self.reset()
    }
    
    public func digest(output: UnsafeMutablePointer<Byte>, outputOffset: Int) {
        self.digest(input: [], inputCount: 0, output: output, outputOffset: outputOffset)
    }

    public func digest(input: [Byte]) -> [Byte] {
        var output = [Byte](repeating: 0, count: self.engine.outputSize)
        self.digest(input: input, inputCount: input.count, output: &output, outputOffset: 0)
        return output
    }

    public func digest() -> [Byte] {
        return self.digest(input: [])
    }
}
