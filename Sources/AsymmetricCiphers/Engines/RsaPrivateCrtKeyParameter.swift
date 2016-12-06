import BigInt

public struct RsaPrivateCrtKeyParameter: PrivateKeyParameter {
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

    public init(modulusString: String, pString: String, qString: String, dpString: String, dqString: String, qInvString: String) {
        self.modulus = BigUInt(modulusString, radix: 16)!
        self.p = BigUInt(pString, radix: 16)!
        self.q = BigUInt(qString, radix: 16)!
        self.dP = BigUInt(dpString, radix: 16)!
        self.dQ = BigUInt(dqString, radix: 16)!
        self.qInv = BigUInt(qInvString, radix: 16)!
    }
}
