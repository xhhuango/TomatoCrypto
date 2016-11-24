import Foundation

public protocol BlockCipherMode {
    func initialize(processMode: BlockCipher.ProcessMode, engine: BlockCipherEngine, parameters: [BlockCipherParameter]) throws
    func process(input: [Byte]) throws -> [Byte]
}
