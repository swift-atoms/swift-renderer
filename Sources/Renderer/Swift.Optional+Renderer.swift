extension Swift.Optional: Renderer.`Protocol` where
    Wrapped: Renderer.`Protocol`,
    Wrapped.Input: ~Copyable & ~Escapable,
    Wrapped.Context: ~Copyable & ~Escapable
{
    public typealias Input = Wrapped.Input
    public typealias Context = Wrapped.Context
    public typealias Failure = Wrapped.Failure

    public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {
        if let renderer = copy self { try renderer.render(input, into: &context) }
    }
}
