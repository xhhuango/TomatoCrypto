import BigInt

public class RsaEngine: AsymmetricBlockCipherEngine {
    private var isEncryption = true
    private var publicKey: RsaPublicKeyParameter!
    private var privateKey: RsaPrivateKeyParameter!

    public var inputBlockSize: Int {
        if self.publicKey != nil {
            return self.publicKey.modulus.count
        } else if self.privateKey != nil {
            return self.privateKey.modulus.count
        } else {
            return 0
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
            guard let key: RsaPrivateKeyParameter = findParameter(within: parameters) else {
                throw CryptoError.missingParameter("\(self) expects \(RsaPrivateKeyParameter.self) for decryption")
            }
            self.privateKey = key
        }

        self.isEncryption = isEncryption
    }
    
    public func processBlock(input: [Byte], offset: Int, length: Int) throws -> [Byte] {
        guard input.count >= offset + length else {
            throw CryptoError.illegalBlockSize("Input length is shorter than offset + length")
        }
        
        if self.publicKey != nil {
            let i = BigUInt(Data(bytes: input))
            let encrypted = self.encryptBlock(e: self.publicKey.e, m: self.publicKey.modulus, input: i)
            return [Byte](encrypted.serialize())
        } else if self.privateKey != nil {
            let i = BigUInt(Data(bytes: input))
            let decrypted = self.decryptBlock(p: self.privateKey.p,
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
    
    func encryptBlock(e: BigUInt, m: BigUInt, input: BigUInt) -> BigUInt {
        // y = (x ^ e) mod m
        return input.power(e, modulus: m)
    }
    
    func decryptBlock(p: BigUInt,
                      q: BigUInt,
                      dP: BigUInt,
                      dQ: BigUInt,
                      qInv: BigUInt,
                      input: BigUInt) -> BigUInt {
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
