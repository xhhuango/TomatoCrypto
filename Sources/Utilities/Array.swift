func xorBytes(input1: UnsafePointer<Byte>, offset1: Int = 0,
              input2: UnsafePointer<Byte>, offset2: Int = 0,
              output: UnsafeMutablePointer<Byte>, offset: Int = 0,
              count: Int) {
    let i1 = input1.advanced(by: offset1)
    let i2 = input2.advanced(by: offset2)
    let o = output.advanced(by: offset)

    for i in 0..<count {
        o[i] = i1[i] ^ i2[i]
    }
}

func copyBytes(from: UnsafePointer<Byte>, fromOffset: Int = 0,
               to: UnsafeMutablePointer<Byte>, toOffset: Int = 0,
               count: Int) {
    memcpy(to.advanced(by: toOffset), from.advanced(by: fromOffset), count)
}

func copyBytes(from: [Byte], to: inout [Byte]) {
    assert(from.count <= to.count)
    memcpy(&to, from, from.count)
}

func compareBytes(from: UnsafePointer<Byte>, fromOffset: Int = 0,
                  to: UnsafePointer<Byte>, toOffset: Int = 0,
                  count: Int) -> Bool {
    return memcmp(from.advanced(by: fromOffset), to.advanced(by: toOffset), count) == 0
}

func fillBytes(byte: Byte, to: UnsafeMutablePointer<Byte>, offset: Int = 0, count: Int) {
    memset(to.advanced(by: offset), Int32(byte), count)
}
