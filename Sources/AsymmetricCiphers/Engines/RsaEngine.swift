import BigInt

public class RsaEngine: AsymmetricCipherEngine {
    private var isEncryption = true
    private var publicKey: RsaPublicKeyParameter!
    private var privateKey: RsaPrivateCrtKeyParameter!

    public var inputSize: Int {
        if self.isEncryption {
            return self.publicKey.modulus.count - 1
        } else {
            return self.privateKey.modulus.count
        }
    }

    public var outputSize: Int {
        if self.isEncryption {
            return self.publicKey.modulus.count
        } else {
            return self.privateKey.modulus.count - 1
        }
    }

    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        self.publicKey = nil
        self.privateKey = nil

        if isEncryption {
            guard let key: RsaPublicKeyParameter = findParameter(within: parameters) else {
                throw CryptoError.missingParameter("\(self) expects \(RsaPublicKeyParameter.self) for encryption")
            }
            self.publicKey = key
        } else {
            guard let key: RsaPrivateCrtKeyParameter = findParameter(within: parameters) else {
                throw CryptoError.missingParameter("\(self) expects \(RsaPrivateCrtKeyParameter.self) for decryption")
            }
            self.privateKey = key
        }

        self.isEncryption = isEncryption
    }
    
    public func process(input: [Byte], offset: Int, length: Int) throws -> [Byte] {
        guard input.count >= offset + length else {
            throw CryptoError.illegalBlockSize("Input length is shorter than offset + length")
        }
        
        if self.publicKey != nil {
            let i = BigUInt(Data(bytes: input))
            let encrypted = self.encrypt(e: self.publicKey.e, m: self.publicKey.modulus, input: i)
            return [Byte](encrypted.serialize())
        } else if self.privateKey != nil {
            let i = BigUInt(Data(bytes: input))
            let decrypted = self.decrypt(p: self.privateKey.p,
                                         q: self.privateKey.q,
                                         dP: self.privateKey.dP,
                                         dQ: self.privateKey.dQ,
                                         qInv: self.privateKey.qInv,
                                         input: i)
            return [Byte](decrypted.serialize())
        } else {
            throw CryptoError.cipherNotInitialize("\(self) is not initialized yet")
        }
    }
    
    func encrypt(e: BigUInt, m: BigUInt, input: BigUInt) -> BigUInt {
        // y = (x ^ e) mod m
        return input.power(e, modulus: m)
    }
    
    func decrypt(p: BigUInt, q: BigUInt, dP: BigUInt, dQ: BigUInt, qInv: BigUInt, input: BigUInt) -> BigUInt {
        // mP = ((input mod p) ^ dP) mod p
        let mP = (input % p).power(dP, modulus: p)
        
        // mQ = ((input mod q) ^ dQ) mod q
        let mQ = (input % q).power(dQ, modulus: q)
        
        // h = (qinv * (mP - mQ)) mod p
        let h = ((mP - mQ) * qInv) % p
        
        // m = h * q + mQ
        let m = h * q + mQ
        
        return m
    }
}
