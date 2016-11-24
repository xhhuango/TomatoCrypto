import Foundation

public protocol BlockCipherMode {
    func initialize(processMode: BlockCipher.ProcessMode, engine: BlockCipherEngine)
    func process(input: [Byte]) throws -> [Byte]
}
