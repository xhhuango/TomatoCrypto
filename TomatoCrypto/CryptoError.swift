import Foundation

public enum CryptoError: Error {
    case illegalKeyLength(String)
    case illegalBlockSize(String)
    case cipherNotInitialize(String)
    
    case cipherNotSet(String)
}
