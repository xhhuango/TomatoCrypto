public protocol MessageDigestEngine {
    var inputSize: Int { get }
    var outputSize: Int { get }
    
    func reset()
    func output(output: UnsafeMutablePointer<Byte>)
    func digestBlock(input: UnsafePointer<Byte>)
    func pad(input: UnsafePointer<Byte>, count: Int) -> [Byte]
}
