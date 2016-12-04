public protocol BlockCipherEngine {
    var blockSize: Int { get }

    func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws
    func reset()
    func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws
}
