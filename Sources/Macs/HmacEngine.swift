public class HmacEngine: MacEngine {
    private let hash: MessageDigest

    private var iKeyPad: [Byte]
    private var oKeyPad: [Byte]

    public var outputSize: Int {
        return self.hash.outputSize
    }

    public init(hash: MessageDigest) {
        self.hash = hash

        self.iKeyPad = [Byte](repeating: 0, count: self.hash.inputSize)
        self.oKeyPad = [Byte](repeating: 0, count: self.hash.inputSize + self.hash.outputSize)
    }

    public func reset() {
        self.hash.reset()
        self.hash.update(input: self.iKeyPad)
    }

    public func initialize(parameters: [CryptoParameter]) throws {
        guard let keyParam: SecretKeyParameter = findParameter(within: parameters) else {
            throw CryptoError.missingParameter("Require \(SecretKeyParameter.self)")
        }

        if keyParam.key.count > self.hash.inputSize {
            self.hash.finalize(input: keyParam.key, inputCount: keyParam.key.count, output: &self.oKeyPad)
        } else {
            copyBytes(from: keyParam.key, to: &self.iKeyPad)
        }
        copyBytes(from: self.iKeyPad, fromOffset: 0, to: &self.oKeyPad, toOffset: 0, count: self.iKeyPad.count)

        for i in 0 ..< self.iKeyPad.count {
            self.iKeyPad[i] ^= 0x36
            self.oKeyPad[i] ^= 0x5c
        }

        self.hash.update(input: self.iKeyPad)
    }

    public func update(input: UnsafePointer<Byte>, count: Int) throws {
        self.hash.update(input: input, count: count)
    }

    public func finalize() throws -> [Byte] {
        self.hash.finalize(output: &self.oKeyPad[self.hash.inputSize])
        return self.hash.finalize(input: self.oKeyPad)
    }
}
