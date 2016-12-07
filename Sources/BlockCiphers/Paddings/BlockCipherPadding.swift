public protocol BlockCipherPadding {
    func add(input: inout [Byte], offset: Int) -> Int
    func padCount(input: [Byte]) -> Int
}
