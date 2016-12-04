import BigInt

public struct RsaPrivateKeyParameter: CryptoParameter {
    public let modulus: BigUInt
    public let d: BigUInt

    public init(modulus: BigUInt, d: BigUInt) {
        self.modulus = modulus
        self.d = d
    }

    public init(modulusString: String, dString: String) {
        self.modulus = BigUInt(modulusString, radix: 16)!
        self.d = BigUInt(dString, radix: 16)!
    }
}
