public struct SaltParameter: CryptoParameter {
    public let salt: [Byte]

    public init(salt: [Byte]) {
        self.salt = salt
    }
}
