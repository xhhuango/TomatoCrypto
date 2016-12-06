public protocol SecretKeyParameter: CryptoParameter {
    var key: [Byte] { get }
}
