public protocol BlockCipherPadding {
    func add(input: [Byte], count: Int) -> [Byte]
    func remove(input: [Byte]) -> [Byte]
}
