public class Sha1Engine: MessageDigestEngine {
    public let inputSize = 64   // 512 bits
    public let outputSize = 20  // 160 bits

    fileprivate let k1: Word = 0x5a827999
    fileprivate let k2: Word = 0x6ed9eba1
    fileprivate let k3: Word = 0x8f1bbcdc
    fileprivate let k4: Word = 0xca62c1d6

    fileprivate var h = [Word](repeating: 0, count: 5)
    fileprivate var w = [Word](repeating: 0, count: 80)

    fileprivate var digestedCount: UInt64 = 0

    public func reset() {
        self.h[0] = 0x67452301
        self.h[1] = 0xefcdab89
        self.h[2] = 0x98badcfe
        self.h[3] = 0x10325476
        self.h[4] = 0xc3d2e1f0

        self.digestedCount = 0
    }

    public func output(output: UnsafeMutablePointer<Byte>) {
        let outputWords = output.withMemoryRebound(to: Word.self, capacity: self.outputSize >> 3) { $0 }
        outputWords[0] = self.h[0].bigEndian
        outputWords[1] = self.h[1].bigEndian
        outputWords[2] = self.h[2].bigEndian
        outputWords[3] = self.h[3].bigEndian
        outputWords[4] = self.h[4].bigEndian
    }
}

extension Sha1Engine {
    public func digestBlock(input: UnsafePointer<Byte>) {
        self.messageSchedule(message: input)

        var a = self.h[0]
        var b = self.h[1]
        var c = self.h[2]
        var d = self.h[3]
        var e = self.h[4]

        var j = 0

        self.stage(&a, &b, &c, &d, &e, &j, self.k1) { b, c, d in (b & c) | (~b & d) }
        self.stage(&a, &b, &c, &d, &e, &j, self.k2) { b, c, d in b ^ c ^ d }
        self.stage(&a, &b, &c, &d, &e, &j, self.k3) { b, c, d in (b & c) | (b & d) | (c & d) }
        self.stage(&a, &b, &c, &d, &e, &j, self.k4) { b, c, d in b ^ c ^ d }

        self.h[0] = self.h[0] &+ a
        self.h[1] = self.h[1] &+ b
        self.h[2] = self.h[2] &+ c
        self.h[3] = self.h[3] &+ d
        self.h[4] = self.h[4] &+ e

        self.digestedCount += UInt64(self.inputSize)
    }

    private func messageSchedule(message: UnsafePointer<Byte>) {
        let wordCount = 16

        let words = message.withMemoryRebound(to: Word.self, capacity: wordCount) { $0 }
        for i in 0..<wordCount {
            self.w[i] = words[i].bigEndian
        }

        for i in wordCount..<self.w.count {
            let word = self.w[i - 16] ^ self.w[i - 14] ^ self.w[i - 8] ^ self.w[i - 3]
            self.w[i] = word << 1 | word >> 31
        }
    }

    private func stage(_ a: inout Word, _ b: inout Word, _ c: inout Word, _ d: inout Word, _ e: inout Word,
                       _ j: inout Int, _ k: Word, f: (Word, Word, Word) -> Word) {
        for _ in 0..<4 {
            e = (a << 5 | a >> 27) &+ f(b, c, d) &+ self.w[j] &+ k &+ e
            j += 1
            b = b << 30 | b >> 2

            d = (e << 5 | e >> 27) &+ f(a, b, c) &+ self.w[j] &+ k &+ d
            j += 1
            a = a << 30 | a >> 2

            c = (d << 5 | d >> 27) &+ f(e, a, b) &+ self.w[j] &+ k &+ c
            j += 1
            e = e << 30 | e >> 2

            b = (c << 5 | c >> 27) &+ f(d, e, a) &+ self.w[j] &+ k &+ b
            j += 1
            d = d << 30 | d >> 2

            a = (b << 5 | b >> 27) &+ f(c, d, e) &+ self.w[j] &+ k &+ a
            j += 1
            c = c << 30 | c >> 2
        }
    }
}

extension Sha1Engine {
    public func pad(input: UnsafePointer<Byte>, count: Int) -> [Byte] {
        let zeroCount = self.inputSize - count - 1 - 8
        var padding = [Byte](repeating: 0, count: zeroCount < 0 ? self.inputSize * 2 : self.inputSize)

        copyBytes(from: input, fromOffset: 0, to: &padding, toOffset: 0, count: count)
        padding[count] = 0x80

        let digested = (self.digestedCount + UInt64(count)) << 3
        let lengthIndex = padding.count - 8
        padding[lengthIndex + 7] = Byte(digested & 0xff)
        padding[lengthIndex + 6] = Byte((digested >> 8) & 0xff)
        padding[lengthIndex + 5] = Byte((digested >> 16) & 0xff)
        padding[lengthIndex + 4] = Byte((digested >> 24) & 0xff)
        padding[lengthIndex + 3] = Byte((digested >> 36) & 0xff)
        padding[lengthIndex + 2] = Byte((digested >> 40) & 0xff)
        padding[lengthIndex + 1] = Byte((digested >> 48) & 0xff)
        padding[lengthIndex + 0] = Byte((digested >> 56) & 0xff)

        return padding
    }
}
