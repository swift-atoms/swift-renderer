#if Empty
public import Empty

extension Empty where Element: Renderable & ~Copyable {
    public struct Renderer: Renderer::Renderer.`Protocol` {
        public typealias Input = Empty<Element>
        public typealias Context = Element.Renderer.Context
        public typealias Failure = Element.Renderer.Failure

        public init() {}

        public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {}
    }
}
#endif
