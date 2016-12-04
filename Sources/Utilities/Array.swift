func xor(input1: UnsafePointer<Byte>, offset1: Int,
         input2: UnsafePointer<Byte>, offset2: Int,
         output: UnsafeMutablePointer<Byte>, offset: Int,
         count: Int, wordMode: Bool) {
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

func copyBytes(from: UnsafePointer<Byte>, fromOffset: Int, to: UnsafeMutablePointer<Byte>, toOffset: Int, count: Int) {
    memcpy(to.advanced(by: toOffset), from.advanced(by: fromOffset), count)
}

func copyBytes(from: [Byte], to: inout [Byte]) {
    assert(from.count <= to.count)
    memcpy(&to, from, from.count)
}

func comparBytes(from: UnsafePointer<Byte>, fromOffset: Int, to: UnsafePointer<Byte>, toOffset: Int, count: Int) -> Bool {
    return memcmp(from.advanced(by: fromOffset), to.advanced(by: toOffset), count) == 0
}
