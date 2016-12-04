import BigInt

public struct RsaPublicKeyParameter: AsymmetricKeyParameter {
    public let modulus: BigUInt
    public let e: BigUInt

    public init(modulus: BigUInt, e: BigUInt) {
        self.modulus = modulus
        self.e = e
    }

    public init(modulusString: String, eString: String) {
        self.modulus = BigUInt(modulusString, radix: 16)!
        self.e = BigUInt(eString, radix: 16)!
    }
}
