public protocol MacEngine {
    var outputSize: Int { get }
    
    func reset()
    func initialize(parameters: [CryptoParameter]) throws
    func update(input: UnsafePointer<Byte>, count: Int) throws
    func finalize() throws -> [Byte]
}
