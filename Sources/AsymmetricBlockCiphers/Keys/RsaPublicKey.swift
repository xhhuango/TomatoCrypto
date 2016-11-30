import BigInt

public struct RsaPublicKey: PublicKey {
    public let modulus: BigUInt
    public let e: BigUInt
    
    public init(modulus: BigUInt, e: BigUInt) {
        self.modulus = modulus
        self.e = e
    }
}
