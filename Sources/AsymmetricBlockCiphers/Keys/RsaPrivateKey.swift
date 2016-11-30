import BigInt

public struct RsaPrivateKey: PrivateKey {
    public let modulus: [Byte]
    public let p: [Byte]
    public let q: [Byte]
    public let dP: [Byte]
    public let dQ: [Byte]
    public let qInv: [Byte]
    
    public init(modulus: [Byte], p: [Byte], q: [Byte], dP: [Byte], dQ: [Byte], qInv: [Byte]) {
        self.modulus = modulus
        self.p = p
        self.q = q
        self.dP = dP
        self.dQ = dQ
        self.qInv = qInv
    }
}
