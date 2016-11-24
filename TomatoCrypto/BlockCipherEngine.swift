import Foundation

public protocol BlockCipherEngine {
    var blockSize: Int { get }
    
    func initialize(processMode: BlockCipher.ProcessMode, key: SecretKey) throws
    func processBlock(input: [Byte]) throws -> [Byte]
}
