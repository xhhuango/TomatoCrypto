import BigInt

public struct RsaPrivateKey: PrivateKey {
    public let modulus: BigUInt
    public let p: BigUInt
    public let q: BigUInt
    public let dP: BigUInt
    public let dQ: BigUInt
    public let qInv: BigUInt
    
    public init(modulus: BigUInt, p: BigUInt, q: BigUInt, dP: BigUInt, dQ: BigUInt, qInv: BigUInt) {
        self.modulus = modulus
        self.p = p
        self.q = q
        self.dP = dP
        self.dQ = dQ
        self.qInv = qInv
    }
}
