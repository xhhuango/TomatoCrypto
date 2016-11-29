func bytesToHex(bytes: UnsafePointer<Byte>, count: Int) -> String {
    let table = [Character]("0123456789ABCDEF".characters)
    var string = String()
    for i in 0..<count {
        let msb = (bytes[i] >> 4) & 0x0f
        string.append(table[Int(msb)])
        let lsb = bytes[i] & 0x0f
        string.append(table[Int(lsb)])
    }
    return string
}

func bytesToHex(bytes: [Byte]) -> String {
    return bytesToHex(bytes: bytes, count: bytes.count)
}

func hexToBytes(hex: String) -> [Byte] {
    let hexBytes = stringToBytes(string: hex)
    var bytes = [Byte](repeating: 0, count: (hexBytes.count - 1) / 2 + 1)
    
    var index = 0
    for byte in hexBytes {
        let value: Byte
        switch byte {
        case 0x30...0x39:
            value = byte - 0x30
        case 0x41...0x46:
            value = byte - 0x41 + 0x0a
        case 0x61...0x66:
            value = byte - 0x61 + 0x0a
        default:
            preconditionFailure("\(byte) is not hex")
        }
        
        let indexBytes = index / 2
        if index % 2 == 0 {
            bytes[indexBytes] |= (value << 4) & 0xf0
        } else {
            bytes[indexBytes] |= value & 0x0f
        }
        
        index += 1
    }
    
    return bytes
}

func stringToBytes(string: String) -> [Byte] {
    return [Byte](string.utf8)
}
