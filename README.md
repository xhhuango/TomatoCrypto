# TomatoCrypto
TomatoCrypto is a cryptographic framwork implemented in pure Swift.

## Platforms
I have only tested it in OSX and iOS, but it should work in all of them because it does not employ any system framworks/libraries.

1. OSX 10.12
2. iOS 10.1
3. watchOS
4. tvOS

## Swift Version
3.0.1

## Package Managers
1. Cocoapods

## Depedencies
TomatoCrypto employs [BigInt](https://github.com/lorentey/BigInt) to compute big integers in RSA.

## Supporting Alogrithms

### Symmetric Block Ciphers
| Name | Required Parameters |
| --------|---------------------|
| AesEngine | SecretKeyParameter |


| Name | Required Parameters |
| --------|---------------------|
| CbcMode | IvParameter |
| CfbMode | IvParameter |
| CtrMode | IvParameter |
| EcbMode |  |
| OfbMode | IvParameter |

| Name |
| --------|
| NoPadding |
| Pkcs7Padding |

### Asymmetric Ciphers
| Name | Required Parameters |
| --------|---------------------|
| RsaEngine | RsaPublicKeyParameter, [RsaPrivateCrtKeyParameter OR RsaPrivateKeyParameter] |

| Name | Required Parameters |
| --------|---------------------|
| OaepPadding | RandomParameter |

### Message Digests
| Name |
| --------|
| Sha1Engine |

### Signatures
| Name | Required Parameters |
| --------|---------------------|
| RsaPssEngine | SaltParameter |

### MACs
| Name | Required Parameters |
| --------|---------------------|
| HmacEngine | SecretKeyParameter |

## Usage
### Symmertic Block Ciphers
```swift
let key = SimpleSecretKeyParameter(key: hexToBytes(hex: "2b7e151628aed2a6abf7158809cf4f3c"))
let plaintext = hexToBytes(hex: "6bc1bee22e409f96e93d7e117393172a" + "ae2d8a571e03ac9c9eb76fac45af8e51")
let ciphertext = hexToBytes(hex: "3ad77bb40d7a3660a89ecaf32466ef97" + "f5d3d58503b9699de785895a96fdbaaf")

let cipher = try instance(blockCipher: .aes, mode: .ecb, padding: .pkcs7, isEncryption: true, parameters: [key])

let encrypted = try cipher.finalize(input: plaintext)
XCTAssertEqual(encrypted, ciphertext)

try cipher.initialize(isEncryption: false, parameters: [key])
let decrypted = try cipher.finalize(input: encrypted)
XCTAssertEqual(decrypted, plaintext)
```

### Asymmetric Ciphers
```swift
let mStr = "bbf82f090682ce9c2338ac2b9da871f7368d07eed41043a440d6b6f07454f51fb8dfbaaf035c02ab61ea48ceeb6fcd4876ed520d60e1ec4619719d8a5b8b807fafb8e0a3dfc737723ee6b4b7d93a2584ee6a649d060953748834b2454598394ee0aab12d7b61a51f527a9a41f6c1687fe2537298ca2a8f5946f8e5fd091dbdcb"
let eStr = "11"
let pStr = "eecfae81b1b9b3c908810b10a1b5600199eb9f44aef4fda493b81a9e3d84f632124ef0236e5d1e3b7e28fae7aa040a2d5b252176459d1f397541ba2a58fb6599"
let qStr = "c97fb1f027f453f6341233eaaad1d9353f6c42d08866b1d05a0f2035028b9d869840b41666b42e92ea0da3b43204b5cfce3352524d0416a5a441e700af461503"
let dpStr = "54494ca63eba0337e4e24023fcd69a5aeb07dddc0183a4d0ac9b54b051f2b13ed9490975eab77414ff59c1f7692e9a2e202b38fc910a474174adc93c1f67c981"
let dqStr = "471e0290ff0af0750351b7f878864ca961adbd3a8a7e991c5c0556a94c3146a7f9803f8f6f8ae342e931fd8ae47a220d1b99a495849807fe39f9245a9836da3d"
let qInvStr = "b06c4fdabb6301198d265bdbae9423b380f271f73453885093077fcd39e2119fc98632154f5883b167a967bf402b4e9e2e0f9656e698ea3666edfb25798039f7"

let seed = hexToBytes(hex: "aafd12f659cae63489b479e5076ddec2f06cb58f")

let plaintext = hexToBytes(hex: "d436e99569fd32a7c8a05bbc90d32c49")
let ciphertext = hexToBytes(hex: "1253e04dc0a5397bb44a7ab87e9bf2a039a33d1e996fc82a94ccd30074c95df763722017069e5268da5d1c0b4f872cf653c11df82314a67968dfeae28def04bb6d84b1c31d654a1970e5783bd6eb96a024c2ca2f4a90fe9f2ef5c9c140e5bb48da9536ad8700c84fc9130adea74e558d51a74ddf85d8b50de96838d6063e0955")

let publicKey = RsaPublicKeyParameter(modulusString: mStr, eString: eStr)
let privateKey = RsaPrivateCrtKeyParameter(modulusString: mStr, pString: pStr, qString: qStr,
                                       dpString: dpStr, dqString: dqStr, qInvString: qInvStr)
let random = RandomParameter() { _, output in
copyBytes(from: seed, fromOffset: 0, to: output, toOffset: 0, count: seed.count)
}

let cipher = try instance(asymmetricCipher: .rsa,
                          padding: .oaep(hash: .sha1, mgfHash: .sha1),
                          isEncryption: true,
                          parameters: [publicKey, random])
let encrypted = try cipher.process(input: plaintext)
XCTAssertEqual(encrypted, ciphertext)

try cipher.initialize(isEncryption: false, parameters: [privateKey])
let decrypted = try cipher.process(input: encrypted)
XCTAssertEqual(decrypted, plaintext)
```

### Message Digests
```swift
let input = stringToBytes(string: "")
let expected = hexToBytes(hex: "da39a3ee5e6b4b0d3255bfef95601890afd80709")

let digest = instance(messageDigest: .sha1)
let output = digest.finalize(input: input)
XCTAssertEqual(output, expected)
```

### Signatures
```swift
let mStr = "bcb47b2e0dafcba81ff2a2b5cb115ca7e757184c9d72bcdcda707a146b3b4e29989ddc660bd694865b932b71ca24a335cf4d339c719183e6222e4c9ea6875acd528a49ba21863fe08147c3a47e41990b51a03f77d22137f8d74c43a5a45f4e9e18a2d15db051dc89385db9cf8374b63a8cc88113710e6d8179075b7dc79ee76b"
let eStr = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001"
let dStr = "383a6f19e1ea27fd08c7fbc3bfa684bd6329888c0bbe4c98625e7181f411cfd0853144a3039404dda41bce2e31d588ec57c0e148146f0fa65b39008ba5835f829ba35ae2f155d61b8a12581b99c927fd2f22252c5e73cba4a610db3973e019ee0f95130d4319ed413432f2e5e20d5215cdd27c2164206b3f80edee51938a25c1"
let saltStr = "6f2841166a64471d4f0b8ed0dbb7db32161da13b"
let msgStr = "1248f62a4389f42f7b4bb131053d6c88a994db2075b912ccbe3ea7dc611714f14e075c104858f2f6e6cfd6abdedf015a821d03608bf4eba3169a6725ec422cd9069498b5515a9608ae7cc30e3d2ecfc1db6825f3e996ce9a5092926bc1cf61aa42d7f240e6f7aa0edb38bf81aa929d66bb5d890018088458720d72d569247b0c"
let sigStr = "682cf53c1145d22a50caa9eb1a9ba70670c5915e0fdfde6457a765de2a8fe12de9794172a78d14e668d498acedad616504bb1764d094607070080592c3a69c343d982bd77865873d35e24822caf43443cc10249af6a1e26ef344f28b9ef6f14e09ad839748e5148bcceb0fd2aa63709cb48975cbf9c7b49abc66a1dc6cb5b31a"

let m = BigUInt(mStr, radix: 16)!
let d = BigUInt(dStr, radix: 16)!
let e = BigUInt(eStr, radix: 16)!
let msg = hexToBytes(hex: msgStr)
let sigBytes = hexToBytes(hex: sigStr)
let privateKey = RsaPrivateKeyParameter(modulus: m, d: d)
let publicKey = RsaPublicKeyParameter(modulus: m, e: e)
let salt = SaltParameter(salt: hexToBytes(hex: saltStr))

let signer = try instance(signature: .rsaPss(hash: .sha1, mgfHash: .sha1),
                          isSigning: true,
                          parameters: [privateKey, salt])
signer.update(input: msg)
let sig = try signer.sign()
XCTAssertEqual(sig, sigBytes)

try signer.initialize(isSigning: false, parameters: [publicKey, salt])
signer.update(input: msg)
let verified = try signer.verify(signature: sig)
XCTAssertTrue(verified)
```

### MACs
```swift
let key = hexToBytes(hex: "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
let msg = stringToBytes(string: "Hi There")
let expected = hexToBytes(hex: "b617318655057264e28bc0b6fb378c8ef146be00")

let keyParam = SimpleSecretKeyParameter(key: key)

let mac = try instance(mac: .hmac(hash: .sha1), parameters: [keyParam])
try mac.update(input: msg)
let code = try mac.finalize()
XCTAssertEqual(code, expected)
```

## Contribute
It is very very welcome for everyone to contribute other cryptographic algorithms.

## License
Apache License, Version 2.0