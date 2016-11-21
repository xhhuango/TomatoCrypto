import Foundation

func bytesToHex(bytes: [UInt8]) -> String {
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

func hexToBytes(hex: String) -> [UInt8] {
    let unicodes = hex.unicodeScalars
    var bytes = [UInt8](repeating: 0, count: (unicodes.count - 1) / 2 + 1)
    
    var index = 0
    for unicode in unicodes {
        var value = UInt8(unicode.value & 0xFF)
        switch value {
        case 0x30...0x39:
            value -= 0x30
        case 0x41...0x46:
            value = value - 0x41 + 0x0A
        case 0x61...0x66:
            value = value - 0x61 + 0x0A
        default:
            preconditionFailure("\(value) is not hex")
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
