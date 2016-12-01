public struct IvParameter: CryptoParameter {
    public let iv: [Byte]
    
    public init(iv: [Byte]) {
        self.iv = iv
    }
}
