public class MessageDigest {
    private let engine: MessageDigestEngine

    private var buffer: [Byte]
    private var bufferIndex = 0

    public init(engine: MessageDigestEngine) {
        self.engine = engine
        engine.reset()
        self.buffer = [Byte](repeating: 0, count: engine.inputSize)
    }

    private func digest(input: [Byte], isFinal: Bool) {
        var count = input.count
        while count > 0 {
            let countEmpty = buffer.count - bufferIndex
            if count >= countEmpty {
                copyBytes(from: input, fromOffset: input.count - count,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: countEmpty)
                count -= countEmpty
                bufferIndex = 0
                self.engine.digestBlock(input: self.buffer)
            } else {
                copyBytes(from: input, fromOffset: input.count - count,
                          to: &self.buffer, toOffset: bufferIndex,
                          count: count)
                bufferIndex += count
                count = 0
            }
        }

        if isFinal {
            let padded = self.engine.pad(input: self.buffer, count: bufferIndex)
            bufferIndex = 0
            self.digest(input: padded, isFinal: false)
        }
    }

    public func update(input: [Byte]) {
        self.digest(input: input, isFinal: false)
    }

    public func finalize(input: [Byte]) -> [Byte] {
        self.digest(input: input, isFinal: true)
        var output = [Byte](repeating: 0, count: self.engine.outputSize)
        self.engine.output(output: &output)
        self.engine.reset()
        return output
    }
}
