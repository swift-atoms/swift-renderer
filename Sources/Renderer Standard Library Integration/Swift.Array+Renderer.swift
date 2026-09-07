public import Renderer

extension Swift.Array: Renderer.`Protocol` where
    Element: Renderer.`Protocol`,
    Element.Input: ~Copyable & ~Escapable,
    Element.Context: ~Copyable & ~Escapable
{
    public typealias Input = Element.Input
    public typealias Context = Element.Context
    public typealias Failure = Element.Failure

    public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {
        for index in 0..<count { try self[index].render(input, into: &context) }
    }
}
