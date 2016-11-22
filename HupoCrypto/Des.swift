import Foundation

public class Des {
    // PC-1 stands for permutation choice one
    let pc1 = [
        57, 49, 41, 33, 25, 17,  9,  1,
        58, 50, 42, 34, 26, 18, 10,  2,
        59, 51, 43, 35, 27, 19, 11,  3,
        60, 52, 44, 36, 63, 55, 47, 39,
        31, 23, 15,  7, 62, 54, 46, 38,
        30, 22, 14,  6, 61, 53, 45, 37,
        29, 21, 13,  5, 28, 20, 12,  4
    ]
    
    // PC-2 stands for permutation choice two
    fileprivate let pc2 = [
        14, 17, 11, 24,  1,  5,  3, 28,
        15,  6, 21, 10, 23, 19, 12,  4,
        26,  8, 16,  7, 27, 20, 13,  2,
        41, 52, 31, 37, 47, 55, 30, 40,
        51, 45, 33, 48, 44, 49, 39, 56,
        34, 53, 46, 42, 50, 36, 29, 32
    ]
    
    let shift = [
        1, 1, 2, 2, 2, 2, 2, 2,
        1, 2, 2, 2, 2, 2, 2, 1
    ]
    
    // IP stands for initial permutation
    fileprivate let ip = [
        58, 50, 42, 34, 26, 18, 10,  2,
        60, 52, 44, 36, 28, 20, 12,  4,
        62, 54, 46, 38, 30, 22, 14,  6,
        64, 56, 48, 40, 32, 24, 16,  8,
        57, 49, 41, 33, 25, 17,  9,  1,
        59, 51, 43, 35, 27, 19, 11,  3,
        61, 53, 45, 37, 29, 21, 13,  5,
        63, 55, 47, 39, 31, 23, 15,  7
    ]
    
    // IIP stands for final (inversed) permutation
    fileprivate let iip = [
        40,  8, 48, 16, 56, 24, 64, 32,
        39,  7, 47, 15, 55, 23, 63, 31,
        38,  6, 46, 14, 54, 22, 62, 30,
        37,  5, 45, 13, 53, 21, 61, 29,
        36,  4, 44, 12, 52, 20, 60, 28,
        35,  3, 43, 11, 51, 19, 59, 27,
        34,  2, 42, 10, 50, 18, 58, 26,
        33,  1, 41,  9, 49, 17, 57, 25
    ]
    
    // E stands for expansion permutation
    fileprivate let e = [
        32,  1,  2,  3,  4,  5,  4,  5,
         6,  7,  8,  9,  8,  9, 10, 11,
        12, 13, 12, 13, 14, 15, 16, 17,
        16, 17, 18, 19, 20, 21, 20, 21,
        22, 23, 24, 25, 24, 25, 26, 27,
        28, 29, 28, 29, 30, 31, 32,  1
    ]
    
    // P stands for permutation which f-Function
    fileprivate let p = [
        16,  7, 20, 21, 29, 12, 28, 17,
         1, 15, 23, 26,  5, 18, 31, 10,
         2,  8, 24, 14, 32, 27,  3,  9,
        19, 13, 30,  6, 22, 11,  4, 25
    ]
    
    fileprivate let sboxes: [[[Byte]]] = [
        [
            [14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7],
            [ 0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8],
            [ 4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0],
            [15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13]
        ],
        [
            [15,  1,  8, 14,  6, 11,  3,  2,  9,  7,  2, 13, 12,  0,  5, 10],
            [ 3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5],
            [ 0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15],
            [13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9]
        ],
        [
            [10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8],
            [13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1],
            [13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7],
            [ 1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12]
        ],
        [
            [ 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15],
            [13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9],
            [10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4],
            [ 3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14]
        ],
        [
            [ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9],
            [14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6],
            [ 4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14],
            [11,  8, 12,  7,  1, 14,  2, 12,  6, 15,  0,  9, 10,  4,  5,  3]
        ],
        [
            [12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11],
            [10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8],
            [ 9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6],
            [ 4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13]
        ],
        [
            [ 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1],
            [13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6],
            [ 1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2],
            [ 6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12]
        ],
        [
            [13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7],
            [ 1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2],
            [ 7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8],
            [ 2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11]
        ]
    ]
    
    fileprivate let smallHexMask: Byte = 0x0F
    fileprivate let bigHexMask: Byte = 0xF0
    fileprivate let shiftHex: Byte = 4
    fileprivate let byteSize = 8
}

extension Des {
    func encryptBlock(data: [Byte], subkeys: [[Byte]]) -> [Byte] {
        precondition(data.count == 8)
        precondition(subkeys.count == 16)
        
        let ipData = self.permute(bytes: data, table: self.ip)
        var (l, r) = self.split(data: ipData)
        for i in 0..<subkeys.count {
            let tmp = r
            r = self.round(left: l, right: r, key: subkeys[i])
            l = tmp
        }
        let joint = self.join(left: r, right: l)
        return self.permute(bytes: joint, table: self.iip)
    }
    
    private func split(data: [Byte]) -> ([Byte], [Byte]) {
        assert(data.count == 8)
        return ([data[0], data[1], data[2], data[3]],
                [data[4], data[5], data[6], data[7]])
    }
    
    private func join(left: [Byte], right: [Byte]) -> [Byte] {
        assert(left.count == 4)
        assert(right.count == 4)
        return [left[0], left[1], left[2], left[3],
                right[0], right[1], right[2], right[3]]
    }
}

extension Des {
    func getBit(bytes: [Byte], index: Int) -> Bool {
        let byteIndex = index / self.byteSize
        assert(byteIndex < bytes.count)
        let bitIndex = 7 - Byte(index % self.byteSize)
        return ((bytes[byteIndex] >> bitIndex) & 0x01) == 0x01
    }
    
    func setBit(bytes: inout [Byte], index: Int, bit: Bool) {
        let byteIndex = index / self.byteSize
        assert(byteIndex < bytes.count)
        let bitIndex = 7 - Byte(index % self.byteSize)
        
        if bit {
            bytes[byteIndex] |= 0x01 << bitIndex
        } else {
            bytes[byteIndex] &= ~(0x01 << bitIndex)
        }
    }
    
    fileprivate func byteCount(bitCount: Int) -> Int {
        assert(bitCount > 0)
        return (bitCount - 1) / self.byteSize + 1
    }
    
    func permute(bytes: [Byte], table: [Int]) -> [Byte] {
        let byteCount = self.byteCount(bitCount: table.count)
        var permuted = [Byte](repeating: 0, count: byteCount)
        for i in 0..<table.count {
            if self.getBit(bytes: bytes, index: table[i] - 1) {
                self.setBit(bytes: &permuted, index: i, bit: true)
            }
        }
        return permuted
    }
}

extension Des {
    func keySchedule(key: [Byte]) -> [[Byte]] {
        let pc1Key = self.permute(bytes: key, table: self.pc1)
        let pc1KeyHalfCount = self.pc1.count / 2
        var (c, d) = self.split(key: pc1Key)
        var subkeys = [[Byte]]()
        for round in 0..<self.shift.count {
            c = self.leftShift(bytes: c, bitCount: pc1KeyHalfCount, shiftCount: self.shift[round])
            d = self.leftShift(bytes: d, bitCount: pc1KeyHalfCount, shiftCount: self.shift[round])
            let joint = self.join(c: c, d: d)
            let pc2Key = self.permute(bytes: joint, table: self.pc2)
            subkeys.append(pc2Key)
        }
        return subkeys
    }
    
    private func split(key: [Byte]) -> ([Byte], [Byte]) {
        assert(key.count == 7)
        
        let c = [key[0], key[1], key[2], key[3] & self.bigHexMask]
        
        let d = [((key[3] << self.shiftHex) & self.bigHexMask) | ((key[4] >> self.shiftHex) & self.smallHexMask),
                 ((key[4] << self.shiftHex) & self.bigHexMask) | ((key[5] >> self.shiftHex) & self.smallHexMask),
                 ((key[5] << self.shiftHex) & self.bigHexMask) | ((key[6] >> self.shiftHex) & self.smallHexMask),
                 ((key[6] << self.shiftHex) & self.bigHexMask)]
        
        return (c, d)
    }
    
    private func join(c: [Byte], d: [Byte]) -> [Byte] {
        assert(c.count == 4)
        assert(d.count == 4)
        return [c[0],
                c[1],
                c[2],
                (c[3] & self.bigHexMask) | ((d[0] >> self.shiftHex) & self.smallHexMask),
                ((d[0] << self.shiftHex) & self.bigHexMask) | ((d[1] >> self.shiftHex) & self.smallHexMask),
                ((d[1] << self.shiftHex) & self.bigHexMask) | ((d[2] >> self.shiftHex) & self.smallHexMask),
                ((d[2] << self.shiftHex) & self.bigHexMask) | ((d[3] >> self.shiftHex) & self.smallHexMask)]
    }
    
    func leftShift(bytes: [Byte], bitCount: Int, shiftCount: Int) -> [Byte] {
        assert(shiftCount > 0)
        
        var bytes = bytes
        let byteCount = self.byteCount(bitCount: bitCount)
        
        let firstCarry = (bytes[0] & 0x80) != 0
        bytes[0] <<= 1
        
        var carry = false
        for i in 1..<byteCount {
            carry = (bytes[i] & 0x80) != 0
            bytes[i] <<= 1
            if carry {
                bytes[i - 1] |= 0x01
            } else {
                bytes[i - 1] &= ~0x01
            }
        }
        
        self.setBit(bytes: &bytes, index: bitCount - 1, bit: firstCarry)
        
        if shiftCount > 1 {
            return self.leftShift(bytes: bytes, bitCount: bitCount, shiftCount: shiftCount - 1)
        } else {
            return bytes
        }
    }
}

extension Des {
    func round(left: [Byte], right: [Byte], key: [Byte]) -> [Byte] {
        assert(left.count == 4)
        assert(right.count == 4)
        let f = self.fFunction(right: right, key: key)
        return self.xor(bytes1: left, bytes2: f)
    }
    
    func fFunction(right: [Byte], key: [Byte]) -> [Byte] {
        assert(right.count == 4)
        assert(key.count == 6)
        
        var tmp = self.permute(bytes: right, table: self.e)
        tmp = self.xor(bytes1: tmp, bytes2: key)
        tmp = self.substitionBoxes(bytes: tmp)
        tmp = self.permute(bytes: tmp, table: self.p)
        return tmp
    }
    
    private func xor(bytes1: [Byte], bytes2: [Byte]) -> [Byte] {
        assert(bytes1.count == bytes2.count)
        var xored = [Byte](repeating: 0, count: bytes1.count)
        for i in 0..<xored.count {
            xored[i] = bytes1[i] ^ bytes2[i]
        }
        return xored
    }
    
    private func substitionBoxes(bytes: [Byte]) -> [Byte] {
        var output = [Byte](repeating: 0, count: 4)
        var row: Int
        var column: Int
        
        // s-box1
        row = Int(((bytes[0] >> 6) & 0x02) | ((bytes[0] >> 2) & 0x01))
        column = Int((bytes[0] >> 3) & self.smallHexMask)
        output[0] = (self.sboxes[0][row][column] << 4) & self.bigHexMask
        
        // s-box2
        row = Int((bytes[0] & 0x02) | ((bytes[1] >> 4) & 0x01))
        column = Int(((bytes[0] << 3) & 0x08) | ((bytes[1] >> 5) & 0x07))
        output[0] |= self.sboxes[1][row][column] & self.smallHexMask
        
        // s-box3
        row = Int(((bytes[1] >> 2) & 0x02) | ((bytes[2] >> 6) & 0x01))
        column = Int(((bytes[1] << 1) & 0x0E) | ((bytes[2] >> 7) & 0x01))
        output[1] = (self.sboxes[2][row][column] << 4) & self.bigHexMask
        
        // s-box4
        row = Int(((bytes[2] >> 4) & 0x02) | (bytes[2] & 0x01))
        column = Int((bytes[2] >> 1) & self.smallHexMask)
        output[1] |= self.sboxes[3][row][column] & self.smallHexMask
        
        // s-box5
        row = Int(((bytes[3] >> 6) & 0x02) | ((bytes[3] >> 2) & 0x01))
        column = Int((bytes[3] >> 3) & self.smallHexMask)
        output[2] = (self.sboxes[4][row][column] << 4) & self.bigHexMask
        
        // s-box6
        row = Int((bytes[3] & 0x02) | ((bytes[4] >> 4) & 0x01))
        column = Int(((bytes[3] << 3) & 0x08) | ((bytes[4] >> 5) & 0x07))
        output[2] |= self.sboxes[5][row][column] & self.smallHexMask
        
        // s-box7
        row = Int(((bytes[4] >> 2) & 0x02) | ((bytes[5] >> 6) & 0x01))
        column = Int(((bytes[4] << 1) & 0x0E) | ((bytes[5] >> 7) & 0x01))
        output[3] = (self.sboxes[6][row][column] << 4) & self.bigHexMask
        
        // s-box8
        row = Int(((bytes[5] >> 4) & 0x02) | (bytes[5] & 0x01))
        column = Int((bytes[5] >> 1) & self.smallHexMask)
        output[3] |= self.sboxes[7][row][column] & self.smallHexMask
        
        return output
    }
}
