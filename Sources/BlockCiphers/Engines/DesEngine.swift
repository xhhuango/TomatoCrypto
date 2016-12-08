public class DesEngine: BlockCipherEngine {
    fileprivate let byteBit: [Byte] = [
        0o200, 0o100, 0o40, 0o20, 0o10, 0o4, 0o2, 0o1
    ]

    fileprivate let bigByte: [Word] = [
        0x800000, 0x400000, 0x200000, 0x100000,
        0x80000,  0x40000,  0x20000,  0x10000,
        0x8000,   0x4000,   0x2000,   0x1000,
        0x800,    0x400,    0x200,    0x100,
        0x80,     0x40,     0x20,     0x10,
        0x8,      0x4,      0x2,      0x1
    ]

    fileprivate let pc1 = [
        56, 48, 40, 32, 24, 16,  8,
        00, 57, 49, 41, 33, 25, 17,
        09,  1, 58, 50, 42, 34, 26,
        18, 10,  2, 59, 51, 43, 35,
        62, 54, 46, 38, 30, 22, 14,
        06, 61, 53, 45, 37, 29, 21,
        13,  5, 60, 52, 44, 36, 28,
        20, 12,  4, 27, 19, 11,  3
    ]

    fileprivate let totrot = [
        1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28
    ]

    fileprivate let pc2 = [
        13, 16, 10, 23,  0,  4,  2, 27,
        14,  5, 20,  9, 22, 18, 11,  3,
        25,  7, 15,  6, 26, 19, 12,  1,
        40, 51, 30, 36, 46, 54, 29, 39,
        50, 44, 32, 47, 43, 48, 38, 55,
        33, 52, 45, 41, 49, 35, 28, 31
    ]

    fileprivate let sp1: [Word] = [
        0x01010400, 0x00000000, 0x00010000, 0x01010404,
        0x01010004, 0x00010404, 0x00000004, 0x00010000,
        0x00000400, 0x01010400, 0x01010404, 0x00000400,
        0x01000404, 0x01010004, 0x01000000, 0x00000004,
        0x00000404, 0x01000400, 0x01000400, 0x00010400,
        0x00010400, 0x01010000, 0x01010000, 0x01000404,
        0x00010004, 0x01000004, 0x01000004, 0x00010004,
        0x00000000, 0x00000404, 0x00010404, 0x01000000,
        0x00010000, 0x01010404, 0x00000004, 0x01010000,
        0x01010400, 0x01000000, 0x01000000, 0x00000400,
        0x01010004, 0x00010000, 0x00010400, 0x01000004,
        0x00000400, 0x00000004, 0x01000404, 0x00010404,
        0x01010404, 0x00010004, 0x01010000, 0x01000404,
        0x01000004, 0x00000404, 0x00010404, 0x01010400,
        0x00000404, 0x01000400, 0x01000400, 0x00000000,
        0x00010004, 0x00010400, 0x00000000, 0x01010004
    ]

    fileprivate let sp2: [Word] = [
        0x80108020, 0x80008000, 0x00008000, 0x00108020,
        0x00100000, 0x00000020, 0x80100020, 0x80008020,
        0x80000020, 0x80108020, 0x80108000, 0x80000000,
        0x80008000, 0x00100000, 0x00000020, 0x80100020,
        0x00108000, 0x00100020, 0x80008020, 0x00000000,
        0x80000000, 0x00008000, 0x00108020, 0x80100000,
        0x00100020, 0x80000020, 0x00000000, 0x00108000,
        0x00008020, 0x80108000, 0x80100000, 0x00008020,
        0x00000000, 0x00108020, 0x80100020, 0x00100000,
        0x80008020, 0x80100000, 0x80108000, 0x00008000,
        0x80100000, 0x80008000, 0x00000020, 0x80108020,
        0x00108020, 0x00000020, 0x00008000, 0x80000000,
        0x00008020, 0x80108000, 0x00100000, 0x80000020,
        0x00100020, 0x80008020, 0x80000020, 0x00100020,
        0x00108000, 0x00000000, 0x80008000, 0x00008020,
        0x80000000, 0x80100020, 0x80108020, 0x00108000
    ]

    fileprivate let sp3: [Word] = [
        0x00000208, 0x08020200, 0x00000000, 0x08020008,
        0x08000200, 0x00000000, 0x00020208, 0x08000200,
        0x00020008, 0x08000008, 0x08000008, 0x00020000,
        0x08020208, 0x00020008, 0x08020000, 0x00000208,
        0x08000000, 0x00000008, 0x08020200, 0x00000200,
        0x00020200, 0x08020000, 0x08020008, 0x00020208,
        0x08000208, 0x00020200, 0x00020000, 0x08000208,
        0x00000008, 0x08020208, 0x00000200, 0x08000000,
        0x08020200, 0x08000000, 0x00020008, 0x00000208,
        0x00020000, 0x08020200, 0x08000200, 0x00000000,
        0x00000200, 0x00020008, 0x08020208, 0x08000200,
        0x08000008, 0x00000200, 0x00000000, 0x08020008,
        0x08000208, 0x00020000, 0x08000000, 0x08020208,
        0x00000008, 0x00020208, 0x00020200, 0x08000008,
        0x08020000, 0x08000208, 0x00000208, 0x08020000,
        0x00020208, 0x00000008, 0x08020008, 0x00020200
    ]

    fileprivate let sp4: [Word] = [
        0x00802001, 0x00002081, 0x00002081, 0x00000080,
        0x00802080, 0x00800081, 0x00800001, 0x00002001,
        0x00000000, 0x00802000, 0x00802000, 0x00802081,
        0x00000081, 0x00000000, 0x00800080, 0x00800001,
        0x00000001, 0x00002000, 0x00800000, 0x00802001,
        0x00000080, 0x00800000, 0x00002001, 0x00002080,
        0x00800081, 0x00000001, 0x00002080, 0x00800080,
        0x00002000, 0x00802080, 0x00802081, 0x00000081,
        0x00800080, 0x00800001, 0x00802000, 0x00802081,
        0x00000081, 0x00000000, 0x00000000, 0x00802000,
        0x00002080, 0x00800080, 0x00800081, 0x00000001,
        0x00802001, 0x00002081, 0x00002081, 0x00000080,
        0x00802081, 0x00000081, 0x00000001, 0x00002000,
        0x00800001, 0x00002001, 0x00802080, 0x00800081,
        0x00002001, 0x00002080, 0x00800000, 0x00802001,
        0x00000080, 0x00800000, 0x00002000, 0x00802080
    ]

    fileprivate let sp5: [Word] = [
        0x00000100, 0x02080100, 0x02080000, 0x42000100,
        0x00080000, 0x00000100, 0x40000000, 0x02080000,
        0x40080100, 0x00080000, 0x02000100, 0x40080100,
        0x42000100, 0x42080000, 0x00080100, 0x40000000,
        0x02000000, 0x40080000, 0x40080000, 0x00000000,
        0x40000100, 0x42080100, 0x42080100, 0x02000100,
        0x42080000, 0x40000100, 0x00000000, 0x42000000,
        0x02080100, 0x02000000, 0x42000000, 0x00080100,
        0x00080000, 0x42000100, 0x00000100, 0x02000000,
        0x40000000, 0x02080000, 0x42000100, 0x40080100,
        0x02000100, 0x40000000, 0x42080000, 0x02080100,
        0x40080100, 0x00000100, 0x02000000, 0x42080000,
        0x42080100, 0x00080100, 0x42000000, 0x42080100,
        0x02080000, 0x00000000, 0x40080000, 0x42000000,
        0x00080100, 0x02000100, 0x40000100, 0x00080000,
        0x00000000, 0x40080000, 0x02080100, 0x40000100
    ]

    fileprivate let sp6: [Word] = [
        0x20000010, 0x20400000, 0x00004000, 0x20404010,
        0x20400000, 0x00000010, 0x20404010, 0x00400000,
        0x20004000, 0x00404010, 0x00400000, 0x20000010,
        0x00400010, 0x20004000, 0x20000000, 0x00004010,
        0x00000000, 0x00400010, 0x20004010, 0x00004000,
        0x00404000, 0x20004010, 0x00000010, 0x20400010,
        0x20400010, 0x00000000, 0x00404010, 0x20404000,
        0x00004010, 0x00404000, 0x20404000, 0x20000000,
        0x20004000, 0x00000010, 0x20400010, 0x00404000,
        0x20404010, 0x00400000, 0x00004010, 0x20000010,
        0x00400000, 0x20004000, 0x20000000, 0x00004010,
        0x20000010, 0x20404010, 0x00404000, 0x20400000,
        0x00404010, 0x20404000, 0x00000000, 0x20400010,
        0x00000010, 0x00004000, 0x20400000, 0x00404010,
        0x00004000, 0x00400010, 0x20004010, 0x00000000,
        0x20404000, 0x20000000, 0x00400010, 0x20004010
    ]

    fileprivate let sp7: [Word] = [
        0x00200000, 0x04200002, 0x04000802, 0x00000000,
        0x00000800, 0x04000802, 0x00200802, 0x04200800,
        0x04200802, 0x00200000, 0x00000000, 0x04000002,
        0x00000002, 0x04000000, 0x04200002, 0x00000802,
        0x04000800, 0x00200802, 0x00200002, 0x04000800,
        0x04000002, 0x04200000, 0x04200800, 0x00200002,
        0x04200000, 0x00000800, 0x00000802, 0x04200802,
        0x00200800, 0x00000002, 0x04000000, 0x00200800,
        0x04000000, 0x00200800, 0x00200000, 0x04000802,
        0x04000802, 0x04200002, 0x04200002, 0x00000002,
        0x00200002, 0x04000000, 0x04000800, 0x00200000,
        0x04200800, 0x00000802, 0x00200802, 0x04200800,
        0x00000802, 0x04000002, 0x04200802, 0x04200000,
        0x00200800, 0x00000000, 0x00000002, 0x04200802,
        0x00000000, 0x00200802, 0x04200000, 0x00000800,
        0x04000002, 0x04000800, 0x00000800, 0x00200002
    ]

    fileprivate let sp8: [Word] = [
        0x10001040, 0x00001000, 0x00040000, 0x10041040,
        0x10000000, 0x10001040, 0x00000040, 0x10000000,
        0x00040040, 0x10040000, 0x10041040, 0x00041000,
        0x10041000, 0x00041040, 0x00001000, 0x00000040,
        0x10040000, 0x10000040, 0x10001000, 0x00001040,
        0x00041000, 0x00040040, 0x10040040, 0x10041000,
        0x00001040, 0x00000000, 0x00000000, 0x10040040,
        0x10000040, 0x10001000, 0x00041040, 0x00040000,
        0x00041040, 0x00040000, 0x10041000, 0x00001000,
        0x00000040, 0x10040040, 0x00001000, 0x00041040,
        0x10001000, 0x00000040, 0x10000040, 0x10040000,
        0x10040040, 0x10000000, 0x00040000, 0x10001040,
        0x00000000, 0x10041040, 0x00040040, 0x10000040,
        0x10040000, 0x10001000, 0x10001040, 0x00000000,
        0x10041040, 0x00041000, 0x00041000, 0x00001040,
        0x00001040, 0x00040040, 0x10000000, 0x10041000
    ]

    public let blockSize: Int = 8
    private let keyLength = 8

    fileprivate var subkeys: [Word]!
    fileprivate var isEncryption = true

    public func reset() {
    }

    public func initialize(isEncryption: Bool, parameters: [CryptoParameter]) throws {
        guard let keyParameter: SecretKeyParameter = findParameter(within: parameters) else {
            throw CryptoError.missingParameter("Require \(SecretKeyParameter.self)")
        }
        let key = keyParameter.key
        guard key.count == self.keyLength else {
            throw CryptoError.illegalKeyLength("Illegal key length. Key must be \(self.keyLength) bytes")
        }

        self.isEncryption = isEncryption

        self.subkeys = self.keySchedule(isEncryption: isEncryption,key: key)
    }

    public func processBlock(input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        try self.processBlock(subkeys: self.subkeys, input: input, output: output)
    }
}

extension DesEngine {
    func processBlock(subkeys: [Word], input: UnsafePointer<Byte>, output: UnsafeMutablePointer<Byte>) throws {
        var work: Word
        var right: Word
        var left: Word

        left  = Word(input[0]) << 24
        left |= Word(input[1]) << 16
        left |= Word(input[2]) <<  8
        left |= Word(input[3])

        right  = Word(input[4]) << 24
        right |= Word(input[5]) << 16
        right |= Word(input[6]) <<  8
        right |= Word(input[7])

        work   = ((left >> 4) ^ right) & 0x0f0f0f0f
        right ^= work
        left  ^= work << 4
        work   = ((left >> 16) ^ right) & 0x0000ffff
        right ^= work
        left  ^= work << 16
        work   = ((right >> 2) ^ left) & 0x33333333
        left  ^= work
        right ^= work << 2
        work   = ((right >> 8) ^ left) & 0x00ff00ff
        left  ^= work
        right ^= work << 8
        right  = ((right << 1) | ((right >> 31) & 0x01)) & 0xffffffff
        work   = (left ^ right) & 0xaaaaaaaa
        left  ^= work
        right ^= work
        left   = ((left << 1) | ((left >> 31) & 0x01)) & 0xffffffff

        for round in 0 ..< 8 {
            var fval: Word
            work  = (right << 28) | (right >> 4)
            work ^= self.subkeys[round * 4 + 0]
            fval  = self.sp7[Int( work        & 0x3f)]
            fval |= self.sp5[Int((work >>  8) & 0x3f)]
            fval |= self.sp3[Int((work >> 16) & 0x3f)]
            fval |= self.sp1[Int((work >> 24) & 0x3f)]
            work  = right ^ self.subkeys[round * 4 + 1];
            fval |= self.sp8[Int( work      & 0x3f)];
            fval |= self.sp6[Int((work >>  8) & 0x3f)];
            fval |= self.sp4[Int((work >> 16) & 0x3f)];
            fval |= self.sp2[Int((work >> 24) & 0x3f)];
            left ^= fval;
            work  = (left << 28) | (left >> 4);
            work ^= self.subkeys[round * 4 + 2];
            fval  = self.sp7[Int( work        & 0x3f)];
            fval |= self.sp5[Int((work >>  8) & 0x3f)];
            fval |= self.sp3[Int((work >> 16) & 0x3f)];
            fval |= self.sp1[Int((work >> 24) & 0x3f)];
            work  = left ^ self.subkeys[round * 4 + 3];
            fval |= self.sp8[Int( work        & 0x3f)];
            fval |= self.sp6[Int((work >>  8) & 0x3f)];
            fval |= self.sp4[Int((work >> 16) & 0x3f)];
            fval |= self.sp2[Int((work >> 24) & 0x3f)];
            right ^= fval;
        }

        right  = (right << 31) | (right >> 1)
        work   = (left ^ right) & 0xaaaaaaaa
        left  ^= work
        right ^= work
        left   = (left << 31) | (left >> 1)
        work   = ((left >> 8) ^ right) & 0x00ff00ff
        right ^= work
        left  ^= work << 8
        work   = ((left >> 2) ^ right) & 0x33333333
        right ^= work
        left  ^= work << 2
        work   = ((right >> 16) ^ left) & 0x0000ffff
        left  ^= work
        right ^= work << 16
        work   = ((right >> 4) ^ left) & 0x0f0f0f0f
        left  ^= work
        right ^= work << 4

        output[0] = Byte((right >> 24) & 0xff)
        output[1] = Byte((right >> 16) & 0xff)
        output[2] = Byte((right >>  8) & 0xff)
        output[3] = Byte( right        & 0xff)
        output[4] = Byte((left  >> 24) & 0xff)
        output[5] = Byte((left  >> 16) & 0xff)
        output[6] = Byte((left  >>  8) & 0xff)
        output[7] = Byte( left         & 0xff)
    }
}

extension DesEngine {
    func keySchedule(isEncryption: Bool, key: [Byte]) -> [Word] {
        var subkeys = [Word](repeating: 0, count: 32)
        var pc1m = [Bool](repeating: false, count: 56)
        var pcr = [Bool](repeating: false, count: 56)

        for i in 0 ..< 56 {
            let l = self.pc1[i]
            pc1m[i] = ((key[l >> 3] & self.byteBit[l & 07]) != 0)
        }

        for i in 0 ..< 16 {
            var l: Int
            let m = (isEncryption) ? i << 1 : (15 - i) << 1
            let n = m + 1

            subkeys[m] = 0
            subkeys[n] = 0

            for j in 0 ..< 28 {
                l = j + self.totrot[i]
                pcr[j] = (l < 28) ? pc1m[l] : pc1m[l - 28]
            }

            for j in 28 ..< 56 {
                l = j + self.totrot[i]
                pcr[j] = (l < 56) ? pc1m[l] : pc1m[l - 28]
            }

            for j in 0 ..< 24 {
                if pcr[self.pc2[j]] {
                    subkeys[m] |= self.bigByte[j]
                }

                if pcr[self.pc2[j + 24]] {
                    subkeys[n] |= self.bigByte[j]
                }
            }
        }

        var i = 0
        while i != 32 {
            let i1 = subkeys[i]
            let i2 = subkeys[i + 1]

            subkeys[i] = ((i1 & 0x00fc0000) << 6) | ((i1 & 0x00000fc0) << 10)
                | ((i2 & 0x00fc0000) >> 10) | ((i2 & 0x00000fc0) >> 6)

            subkeys[i + 1] = ((i1 & 0x0003f000) << 12) | ((i1 & 0x0000003f) << 16)
                | ((i2 & 0x0003f000) >> 4) | (i2 & 0x0000003f)
            
            i += 2
        }
        
        return subkeys
    }
}
