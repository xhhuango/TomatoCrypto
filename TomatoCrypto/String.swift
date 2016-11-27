import Foundation

func bytesToHex(bytes: [Byte]) -> String {
    let table = [Character]("0123456789ABCDEF".characters)
    var string = String()
    for byte in bytes {
        let msb = (byte >> 4) & 0x0F
        string.append(table[Int(msb)])
        let lsb = byte & 0x0F
        string.append(table[Int(lsb)])
    }
    return string
}

func bytesToHex(bytes: UnsafePointer<Byte>, count: Int) -> String {
    let table = [Character]("0123456789ABCDEF".characters)
    var string = String()
    for i in 0..<count {
        let msb = (bytes[i] >> 4) & 0x0F
        string.append(table[Int(msb)])
        let lsb = bytes[i] & 0x0F
        string.append(table[Int(lsb)])
    }
    return string
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
            value = byte - 0x41 + 0x0A
        case 0x61...0x66:
            value = byte - 0x61 + 0x0A
        default:
            preconditionFailure("\(byte) is not hex")
        }
        
        let indexBytes = index / 2
        if index % 2 == 0 {
            bytes[indexBytes] |= (value << 4) & 0xF0
        } else {
            bytes[indexBytes] |= value & 0x0F
        }
        
        index += 1
    }
    
    return bytes
}

func stringToBytes(string: String) -> [Byte] {
    return [Byte](string.utf8)
}
