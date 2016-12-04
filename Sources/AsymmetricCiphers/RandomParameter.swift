public struct RandomParameter: CryptoParameter {
    public private(set) var random: (Int, UnsafeMutablePointer<Byte>) -> ()

    public init() {
        self.random = { count, output in
            _ = SecRandomCopyBytes(kSecRandomDefault, count, output)
        }
    }

    public init(random: @escaping (Int, UnsafeMutablePointer<Byte>) -> ()) {
        self.random = random
    }
}

