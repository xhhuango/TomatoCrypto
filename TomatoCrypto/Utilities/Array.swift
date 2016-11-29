func xor(input1: UnsafePointer<Byte>,
         offset1: Int,
         input2: UnsafePointer<Byte>,
         offset2: Int,
         output: UnsafeMutablePointer<Byte>,
         offset: Int,
         count: Int,
         wordMode: Bool) {
    if wordMode {
        let i1 = input1.advanced(by: offset1).withMemoryRebound(to: Word.self, capacity: count) { $0 }
        let i2 = input2.advanced(by: offset2).withMemoryRebound(to: Word.self, capacity: count) { $0 }
        let o = output.advanced(by: offset).withMemoryRebound(to: Word.self, capacity: count) { $0 }
        
        for i in 0..<count {
            o[i] = i1[i] ^ i2[i]
        }
    } else {
        let i1 = input1.advanced(by: offset1).withMemoryRebound(to: Byte.self, capacity: count) { $0 }
        let i2 = input2.advanced(by: offset2).withMemoryRebound(to: Byte.self, capacity: count) { $0 }
        let o = output.advanced(by: offset).withMemoryRebound(to: Byte.self, capacity: count) { $0 }
        
        for i in 0..<count {
            o[i] = i1[i] ^ i2[i]
        }
    }
}

func xorWord(input1: [Byte], input2: [Byte], output: inout [Byte]) {
    output[0] = input1[0] ^ input2[0]
    output[1] = input1[1] ^ input2[1]
    output[2] = input1[2] ^ input2[2]
    output[3] = input1[3] ^ input2[3]
}

func leftRotateWord(input: UnsafeMutablePointer<Byte>, shiftBits: Word) {
    let word = input.withMemoryRebound(to: Word.self, capacity: 1) { $0 }
    word[0] = ((word[0] >> shiftBits) & (0xFFFFFFFF >> shiftBits)) | ((word[0] << (32 - shiftBits)) & (0xFFFFFFFF << (32 - shiftBits)))
}

func rightRotateWord(input: UnsafeMutablePointer<Byte>, shiftBits: Word) {
    let word = input.withMemoryRebound(to: Word.self, capacity: 1) { $0 }
    word[0] = ((word[0] << shiftBits) & (0xFFFFFFFF << shiftBits)) | ((word[0] >> (32 - shiftBits)) & (0xFFFFFFFF >> (32 - shiftBits)))
}

func copyBytes(from: UnsafePointer<Byte>, fromOffset: Int, to: UnsafeMutablePointer<Byte>, toOffset: Int, count: Int) {
    let f = from.advanced(by: fromOffset).withMemoryRebound(to: Byte.self, capacity: count) { $0 }
    let t = to.advanced(by: toOffset).withMemoryRebound(to: Byte.self, capacity: count) { $0 }
    NSCopyMemoryPages(f, t, count)
}
