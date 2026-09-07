extension Swift.Optional: Renderer.`Protocol` where
    Wrapped: Renderer.`Protocol` & ~Copyable,
    Wrapped.Input: ~Copyable & ~Escapable,
    Wrapped.Context: ~Copyable & ~Escapable
{
    public typealias Input = Wrapped.Input
    public typealias Context = Wrapped.Context
    public typealias Failure = Wrapped.Failure

    public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {
        switch self {
        case .some(let renderer): try renderer.render(input, into: &context)
        case .none: break
        }
    }
}
