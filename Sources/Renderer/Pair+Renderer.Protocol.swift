public import Pair

extension Pair: Renderer.`Protocol`
where
    First: Renderer.`Protocol` & ~Copyable,
    Second: Renderer.`Protocol` & ~Copyable,
    First.Input: ~Copyable & ~Escapable,
    Second.Input: ~Copyable & ~Escapable,
    First.Context: ~Copyable & ~Escapable,
    Second.Context: ~Copyable & ~Escapable,
    First.Input == Second.Input,
    First.Context == Second.Context,
    First.Failure == Second.Failure
{
    public typealias Input = First.Input
    public typealias Context = First.Context
    public typealias Failure = First.Failure

    public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {
        try first.render(input, into: &context)
        try second.render(input, into: &context)
    }
}
