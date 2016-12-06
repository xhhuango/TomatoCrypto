public class RsaPssEngine: SignatureEngine {
    private let cipher: AsymmetricCipherEngine
    private let hash: MessageDigest
    private let mgfHash: MessageDigest
    private var salt: [Byte] = []

    public init(cipher: AsymmetricCipherEngine, hash: MessageDigest, mgfHash: MessageDigest) {
        self.cipher = cipher
        self.hash = hash
        self.mgfHash = mgfHash
    }

    public func initialize(isSigning: Bool, parameters: [CryptoParameter]) throws {
        try self.cipher.initialize(isEncryption: !isSigning, parameters: parameters)

        if let saltParam: SaltParameter = findParameter(within: parameters) {
            self.salt = saltParam.salt
        }
    }

    public func reset() {
        self.hash.reset()
        self.mgfHash.reset()
        self.salt = []
    }

    public func update(input: UnsafePointer<Byte>, count: Int) {
        self.hash.update(input: input, count: count)
    }

    public func sign() throws -> [Byte] {
        var em = [Byte](repeating: 0, count: self.cipher.inputSize)

        var m = [Byte](repeating: 0, count: 8 + self.hash.outputSize + self.salt.count)
        if self.salt.count != 0 {
            copyBytes(from: salt, fromOffset: 0, to: &m, toOffset: m.count - self.salt.count, count: self.salt.count)
        }
        self.hash.finalize(output: &m[8])

        let dbCount = em.count - 1 - self.hash.outputSize
        self.hash.finalize(input: m, inputCount: m.count, output: &em[dbCount])

        var db = [Byte](repeating: 0, count: dbCount)
        if self.salt.count != 0 {
            copyBytes(from: self.salt, fromOffset: 0, to: &db, toOffset: dbCount - self.salt.count, count: self.salt.count)
        }
        db[db.count - self.salt.count - 1] = 0x01

        xorBytes(input1: db,
                 input2: self.mgf1(data: em, dataOffset: dbCount, dataCount: self.hash.outputSize, maskCount: dbCount),
                 output: &em,
                 count: dbCount)

        em[em.count - 1] = 0xbc

        return try self.cipher.process(input: em, count: em.count)
    }

    public func verify(signature: UnsafePointer<Byte>, count: Int) throws -> Bool {
        let em = try self.cipher.process(input: signature, count: count)
        if em[em.count - 1] != 0xbc {
            return false
        }

        var m = [Byte](repeating: 0, count: 8 + self.hash.outputSize + self.salt.count)
        if self.salt.count != 0 {
            copyBytes(from: salt, fromOffset: 0, to: &m, toOffset: m.count - self.salt.count, count: self.salt.count)
        }
        self.hash.finalize(output: &m[8])

        let h = self.hash.finalize(input: m)

        let dbCount = em.count - 1 - self.hash.outputSize
        let dbMask = self.mgf1(data: em, dataOffset: dbCount, dataCount: self.hash.outputSize, maskCount: dbCount)

        var db = [Byte](repeating: 0, count: dbCount)
        xorBytes(input1: em, input2: dbMask, output: &db, count: dbCount)
        if db[db.count - self.salt.count - 1] != 0x01 {
            return false
        }
        for i in 0 ..< (db.count - self.salt.count - 1) {
            if db[i] != 0 {
                return false
            }
        }

        return compareBytes(from: h, fromOffset: 0, to: em, toOffset: em.count - h.count - 1, count: h.count)
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
            self.mgfHash.finalize(input: c, inputCount: c.count, output: &mask[Int(counter) * self.mgfHash.outputSize])

            counter += 1
        }

        if ((Int(counter) * self.mgfHash.outputSize) < maskCount) {
            var output = [Byte](repeating: 0, count: self.mgfHash.outputSize)

            self.i2Osp(input: counter, output: &c)

            self.mgfHash.update(input: data, count: dataCount)
            self.mgfHash.finalize(input: c, inputCount: c.count, output: &output)

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
