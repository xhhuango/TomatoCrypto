import Foundation

import BigInt

public class RsaEngine {
    func encryptBlock(e: BigUInt, m: BigUInt, input: BigUInt) -> BigUInt {
        // y = (x ^ e) mod m
        return input.power(e, modulus: m)
    }
    
    func decryptBlock(d: BigUInt,
                      p: BigUInt,
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
