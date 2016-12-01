public protocol CryptoParameter {
}

func findParameter<T>(within parameters: [CryptoParameter]) -> T? {
    for parameter in parameters {
        if parameter is T {
            return parameter as? T
        }
    }
    return nil
}
