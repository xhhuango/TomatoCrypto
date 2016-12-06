public struct SimpleSecretKeyParameter: SecretKeyParameter {
    public let key: [Byte]

    public init(key: [Byte]) {
        self.key = key
    }
}
