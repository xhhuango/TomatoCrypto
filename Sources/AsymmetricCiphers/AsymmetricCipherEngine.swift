public protocol AsymmetricCipherEngine {
    var inputSize: Int { get }
    var outputSize: Int { get }
    
    func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws
    func process(input: [Byte], offset: Int, length: Int) throws -> [Byte]
}
