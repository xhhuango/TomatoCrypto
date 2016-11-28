import Foundation

public struct SecretKey {
    public let bytes: [Byte]
    
    public init(bytes: [Byte]) {
        self.bytes = bytes
    }
}
