public protocol SignatureEngine {
    func initialize(isSigning: Bool, parameters: [CryptoParameter]) throws
    func reset()
    func update(input: UnsafePointer<Byte>, count: Int)
    func sign() throws -> [Byte]
    func verify(signature: UnsafePointer<Byte>, count: Int) throws -> Bool
}
