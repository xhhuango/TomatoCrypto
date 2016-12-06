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

    public func update(input: [Byte]) {
        self.update(input: input, count: input.count)
    }

    @discardableResult
    public func finalize(input: UnsafePointer<Byte>, inputCount: Int, output: UnsafeMutablePointer<Byte>) -> Int {
        self.digest(input: input, count: inputCount, isFinal: true)
        self.engine.output(output: output)
        self.reset()
        return self.outputSize
    }
    
    @discardableResult
    public func finalize(input: [Byte] = [], output: UnsafeMutablePointer<Byte>) -> Int {
        return self.finalize(input: input, inputCount: input.count, output: output)
    }

    public func finalize(input: UnsafePointer<Byte>, count: Int) -> [Byte] {
        var output = [Byte](repeating: 0, count: self.engine.outputSize)
        self.finalize(input: input, inputCount: count, output: &output)
        return output
    }

    public func finalize(input: [Byte] = []) -> [Byte] {
        return self.finalize(input: input, count: input.count)
    }
}
