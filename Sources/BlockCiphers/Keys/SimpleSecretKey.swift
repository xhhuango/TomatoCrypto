public struct SimpleSecretKey: SecretKey {
    public let bytes: [Byte]
    
    public init(bytes: [Byte]) {
        self.bytes = bytes
    }
}
