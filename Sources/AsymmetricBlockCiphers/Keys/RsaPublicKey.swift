public struct RsaPublicKey: PublicKey {
    public let modulus: [Byte]
    public let publicExponent: [Byte]
    
    public init(modulus: [Byte], publicExponent: [Byte]) {
        self.modulus = modulus
        self.publicExponent = publicExponent
    }
}
