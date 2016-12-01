public struct SimpleSymmetricKeyParameter: SymmetricKeyParameter {
    public let key: [Byte]

    public init(key: [Byte]) {
        self.key = key
    }
}
