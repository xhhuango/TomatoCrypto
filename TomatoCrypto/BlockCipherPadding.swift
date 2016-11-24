import Foundation

public protocol BlockCipherPadding {
    func add(input: [Byte], cout: Int) -> [Byte]
    func remove(input: [Byte]) -> [Byte]
}
