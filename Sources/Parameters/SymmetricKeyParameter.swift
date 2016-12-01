public protocol SymmetricKeyParameter: CryptoParameter {
    var key: [Byte] { get }
}
