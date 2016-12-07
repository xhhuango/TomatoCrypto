public enum BlockCiphers {
    case aes
    case des
}

public enum BlockCipherModes {
    case ecb
    case cbc
    case cfb
    case ctr
    case ofb
}

public enum BlockCipherPaddings {
    case no
    case pkcs7
}

public enum AsymmetricCiphers {
    case rsa
}

public enum AsymmetricCipherPaddings {
    case oaep(hash: MessageDigests, mgfHash: MessageDigests)
}

public enum MessageDigests {
    case sha1
}

public enum Signatures {
    case rsaPss(hash: MessageDigests, mgfHash: MessageDigests)
}

public enum Macs {
    case hmac(hash: MessageDigests)
}

public func instance(blockCipher: BlockCiphers, mode: BlockCipherModes, padding: BlockCipherPaddings,
                     isEncryption: Bool, parameters: [CryptoParameter]) throws -> BlockCipher {
    let cipherEngine: BlockCipherEngine
    switch blockCipher {
    case .aes:
        cipherEngine = AesEngine()
    case .des:
        cipherEngine = DesEngine()
    }

    let modeEngine: BlockCipherEngine
    switch mode {
    case .ecb:
        modeEngine = EcbMode(engine: cipherEngine)
    case .cbc:
        modeEngine = CbcMode(engine: cipherEngine)
    case .cfb:
        modeEngine = CfbMode(engine: cipherEngine)
    case .ctr:
        modeEngine = CtrMode(engine: cipherEngine)
    case .ofb:
        modeEngine = OfbMode(engine: cipherEngine)
    }

    let paddingEngine: BlockCipherPadding
    switch padding {
    case .no:
        paddingEngine = NoPadding()
    case .pkcs7:
        paddingEngine = Pkcs7Padding()
    }

    return try BlockCipher(engine: modeEngine, padding: paddingEngine)
        .initialize(isEncryption: isEncryption, parameters: parameters)
}

public func instance(asymmetricCipher: AsymmetricCiphers, padding: AsymmetricCipherPaddings,
                     isEncryption: Bool, parameters: [CryptoParameter]) throws -> AsymmetricCipher {
    let cipherEngine: AsymmetricCipherEngine
    switch asymmetricCipher {
    case .rsa:
        cipherEngine = RsaEngine()
    }

    let paddingEngine: AsymmetricCipherEngine
    switch padding {
    case .oaep(let hash, let mgfHash):
        paddingEngine = OaepPadding(engine: cipherEngine,
                                    hash: instance(messageDigest: hash),
                                    mgfHash: instance(messageDigest: mgfHash))
    }

    return try AsymmetricCipher(engine: paddingEngine).initialize(isEncryption: isEncryption, parameters: parameters)
}

public func instance(messageDigest: MessageDigests) -> MessageDigest {
    let digestEngine: MessageDigestEngine
    switch messageDigest {
    case .sha1:
        digestEngine = Sha1Engine()
    }

    return MessageDigest(engine: digestEngine)
}

public func instance(signature: Signatures, isSigning: Bool, parameters: [CryptoParameter]) throws -> Signature {
    let signatureEngine: SignatureEngine
    switch signature {
    case .rsaPss(let hash, let mgfHash):
        signatureEngine = RsaPssEngine(cipher: RsaEngine(),
                                       hash: instance(messageDigest: hash),
                                       mgfHash: instance(messageDigest: mgfHash))
    }

    return try Signature(engine: signatureEngine).initialize(isSigning: isSigning, parameters: parameters)
}

public func instance(mac: Macs, parameters: [CryptoParameter]) throws -> Mac {
    let macEngine: MacEngine
    switch mac {
    case .hmac(let hash):
        macEngine = HmacEngine(hash: instance(messageDigest: hash))
    }

    return try Mac(engine: macEngine).initialize(parameters: parameters)
}
