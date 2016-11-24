import Foundation

public protocol BlockCipherEngine {
    var blockSize: Int { get }
    
    func initialize(processMode: BlockCipher.ProcessMode, key: [Byte]) throws
    func processBlock(input: [Byte]) throws -> [Byte]
}
