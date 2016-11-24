import Foundation

public struct IvParameter: BlockCipherParameter {
    public let bytes: [Byte]
    
    public init(bytes: [Byte]) {
        self.bytes = bytes
    }
}
