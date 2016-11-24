import Foundation

func xorBytes(bytes1: [Byte], bytes2: [Byte]) -> [Byte] {
    assert(bytes1.count == bytes2.count)
    var xored = [Byte](repeating: 0, count: bytes1.count)
    for i in 0..<xored.count {
        xored[i] = bytes1[i] ^ bytes2[i]
    }
    return xored
}
