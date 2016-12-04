public enum CryptoError: Error {
    case illegalKeyLength(String)
    case illegalBlockSize(String)
    case cipherNotInitialize(String)
    case missingParameter(String)
    case invalidParameter(String)
    case illegalDataLength(String)
    case invalidCipherText(String)
}
