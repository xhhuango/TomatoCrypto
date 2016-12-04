public class OaepPadding: AsymmetricCipherEngine {
    private let engine: AsymmetricCipherEngine
    private let mgfHash: MessageDigest
    private let hash: MessageDigest
    private let label: [Byte] = []
    private var hashedLabel: [Byte]
    
    private var isEncryption = true
    private var random: RandomParameter = RandomParameter()
    
    public var inputSize: Int {
        return self.engine.inputSize - 2 - self.hash.outputSize * 2
    }

    public var outputSize: Int {
        return self.engine.outputSize
    }

    public init(engine: AsymmetricCipherEngine, mgfHash: MessageDigest, hash: MessageDigest) {
        self.engine = engine
        self.mgfHash = mgfHash
        self.hash = hash

        self.hashedLabel = [Byte](repeating: 0, count: hash.outputSize)
    }
    
    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        try self.engine.initialize(isEncryption: isEncryption, parameters: parameters)

        if let random: RandomParameter = findParameter(within: parameters) {
            self.random = random
        }
        
        self.hash.digest(input: [], inputCount: 0, output: &self.hashedLabel, outputOffset: 0)
        self.isEncryption = isEncryption
    }

    public func process(input: UnsafePointer<Byte>, count: Int) throws -> [Byte] {
        if self.isEncryption {
            return try self.encrypt(input: input, count: count)
        } else {
            return try self.decrypt(input: input, count: count)
        }
    }
    
    private func encrypt(input: UnsafePointer<Byte>, count: Int) throws -> [Byte] {
        let wordSize = MemoryLayout<Word>.size
        var padded = [Byte](repeating: 0, count: self.engine.inputSize)

        let dbIndex = self.hash.outputSize
        let dbCount = padded.count - dbIndex
        copyBytes(from: input, fromOffset: 0, to: &padded, toOffset: padded.count - count, count: count)
        padded[padded.count - count - 1] = 0x01
        copyBytes(from: self.hashedLabel, fromOffset: 0, to: &padded, toOffset: dbIndex, count: self.hashedLabel.count)

        self.random.random(self.hash.outputSize, &padded)

        let dbMask = self.mgf1(data: padded, dataOffset: 0, dataCount: self.hash.outputSize, maskCount: dbCount)
        var xorWordMode = dbCount % wordSize == 0
        xor(input1: dbMask, offset1: 0,
            input2: padded, offset2: dbIndex,
            output: &padded, offset: dbIndex,
            count: xorWordMode ? dbCount / wordSize : dbCount, wordMode: xorWordMode)

        let seedMask = self.mgf1(data: padded, dataOffset: dbIndex, dataCount: dbCount, maskCount: self.hash.outputSize)
        xorWordMode = self.hash.outputSize % wordSize == 0
        xor(input1: seedMask, offset1: 0,
            input2: padded, offset2: 0,
            output: &padded, offset: 0,
            count: xorWordMode ? self.hash.outputSize / wordSize : self.hash.outputSize, wordMode: xorWordMode)

        return try self.engine.process(input: padded, count: padded.count)
    }

    private func decrypt(input: UnsafePointer<Byte>, count: Int) throws -> [Byte] {
        let wordSize = MemoryLayout<Word>.size
        var padded = try self.engine.process(input: input, count: count)

        let dbIndex = self.hash.outputSize
        let dbCount = padded.count - dbIndex

        let seedMask = self.mgf1(data: padded, dataOffset: dbIndex, dataCount: dbCount, maskCount: self.hash.outputSize)
        var xorWordMode = self.hash.outputSize % wordSize == 0
        xor(input1: seedMask, offset1: 0,
            input2: padded, offset2: 0,
            output: &padded, offset: 0,
            count: xorWordMode ? self.hash.outputSize / wordSize : self.hash.outputSize, wordMode: xorWordMode)
        
        let dbMask = self.mgf1(data: padded, dataOffset: 0, dataCount: self.hash.outputSize, maskCount: dbCount)
        xorWordMode = dbCount % wordSize == 0
        xor(input1: dbMask, offset1: 0,
            input2: padded, offset2: dbIndex,
            output: &padded, offset: dbIndex,
            count: xorWordMode ? dbCount / wordSize : dbCount, wordMode: xorWordMode)

        guard comparBytes(from: self.hashedLabel, fromOffset: 0,
                          to: padded, toOffset: dbIndex,
                          count: self.hash.outputSize) else {
            throw CryptoError.invalidCipherText("Data wrong")
        }

        var msgIndex = self.hash.outputSize * 2
        for i in msgIndex ..< padded.count {
            if padded[i] != 0x00 {
                msgIndex = i
                break
            }
        }
        guard msgIndex < padded.count && padded[msgIndex] == 0x01 else {
            throw CryptoError.invalidCipherText("Data wrong")
        }
        msgIndex += 1

        var msg = [Byte](repeating: 0, count: padded.count - msgIndex)
        copyBytes(from: padded, fromOffset: msgIndex, to: &msg, toOffset: 0, count: msg.count)

        return msg
    }

    private func mgf1(data: UnsafePointer<Byte>, dataOffset: Int, dataCount: Int, maskCount: Int) -> [Byte] {
        let data = data.advanced(by: dataOffset)
        var counter: UInt32 = 0
        var c = [Byte](repeating: 0, count: 4)
        let mgfTimes = UInt32(maskCount / self.mgfHash.outputSize)
        var mask = [Byte](repeating: 0, count: maskCount)

        while counter < mgfTimes {
            self.i2Osp(input: counter, output: &c)
            
            self.mgfHash.update(input: data, count: dataCount)
            self.mgfHash.digest(input: c, inputCount: c.count,
                                output: &mask, outputOffset: Int(counter) * self.mgfHash.outputSize)

            counter += 1
        }

        if ((Int(counter) * self.mgfHash.outputSize) < maskCount) {
            var output = [Byte](repeating: 0, count: self.mgfHash.outputSize)
            
            self.i2Osp(input: counter, output: &c)

            self.mgfHash.update(input: data, count: dataCount)
            self.mgfHash.digest(input: c, inputCount: c.count, output: &output, outputOffset: 0)

            copyBytes(from: output, fromOffset: 0,
                      to: &mask, toOffset: Int(counter) * self.mgfHash.outputSize,
                      count: mask.count - Int(counter) * self.mgfHash.outputSize)
        }

        return mask
    }

    private func i2Osp(input: UInt32, output: inout [Byte]) {
        output[0] = Byte(input >> 24)
        output[1] = Byte(input >> 16)
        output[2] = Byte(input >> 8)
        output[3] = Byte(input)
    }
}
