import BigInt

public class RsaEngine: AsymmetricCipherEngine {
    private var isEncryption = true
    private var publicKey: RsaPublicKeyParameter!
    private var privateCrtKey: RsaPrivateCrtKeyParameter!
    private var privateKey: RsaPrivateKeyParameter!

    public var inputSize = 0
    public var outputSize = 0

    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        self.publicKey = nil
        self.privateCrtKey = nil
        self.privateKey = nil

        if isEncryption {
            guard let key: RsaPublicKeyParameter = findParameter(within: parameters) else {
                throw CryptoError.missingParameter("\(self) expects \(RsaPublicKeyParameter.self) for encryption")
            }
            self.publicKey = key
            self.outputSize = [Byte](self.publicKey.modulus.serialize()).count
            self.inputSize = self.outputSize - 1
        } else {
            if let key: RsaPrivateCrtKeyParameter = findParameter(within: parameters) {
                self.privateCrtKey = key
                self.inputSize = [Byte](self.privateCrtKey.modulus.serialize()).count
                self.outputSize = self.inputSize - 1
            } else if let key: RsaPrivateKeyParameter = findParameter(within: parameters) {
                self.privateKey = key
                self.inputSize = [Byte](self.privateKey.modulus.serialize()).count
                self.outputSize = self.inputSize - 1
            } else {
                throw CryptoError.missingParameter("\(self) expects \(RsaPrivateCrtKeyParameter.self) or \(RsaPrivateKeyParameter.self) for decryption")
            }
        }

        self.isEncryption = isEncryption
    }

    public func process(input: UnsafePointer<Byte>, count: Int) throws -> [Byte] {
        let result: BigUInt
        let i = BigUInt(Data(bytes: input, count: count))
        if self.publicKey != nil {
            result = self.encrypt(e: self.publicKey.e, m: self.publicKey.modulus, input: i)
        } else if self.privateCrtKey != nil {
            result = self.crtDecrypt(p: self.privateCrtKey.p,
                                     q: self.privateCrtKey.q,
                                     dP: self.privateCrtKey.dP,
                                     dQ: self.privateCrtKey.dQ,
                                     qInv: self.privateCrtKey.qInv,
                                     input: i)
        } else if self.privateKey != nil {
            result = self.decrypt(d: self.privateKey.d, m: self.privateKey.modulus, input: i)
        } else {
            throw CryptoError.cipherNotInitialize("\(self) is not initialized yet")
        }
        return [Byte](result.serialize())
    }

    func encrypt(e: BigUInt, m: BigUInt, input: BigUInt) -> BigUInt {
        // y = (x ^ e) mod m
        return input.power(e, modulus: m)
    }

    func crtDecrypt(p: BigUInt, q: BigUInt, dP: BigUInt, dQ: BigUInt, qInv: BigUInt, input: BigUInt) -> BigUInt {
        // mP = ((input mod p) ^ dP) mod p
        let mP = (input % p).power(dP, modulus: p)

        // mQ = ((input mod q) ^ dQ) mod q
        let mQ = (input % q).power(dQ, modulus: q)

        // h = (qinv * (mP - mQ)) mod p
        let h = ((((mP > mQ) ? mP : mP + p) - mQ) * qInv) % p

        // m = h * q + mQ
        let m = h * q + mQ

        return m
    }

    func decrypt(d: BigUInt, m: BigUInt, input: BigUInt) -> BigUInt {
        // y = (x ^ d) mod m
        return input.power(d, modulus: m)
    }
}
