import Foundation

public typealias Byte = UInt8

public protocol CipherKey {
}

public protocol Cipher {
    associatedtype CipherKey
    func encrypt(key: CipherKey, data: Data) -> Data
    func decrypt(key: CipherKey, data: Data) -> Data
}
