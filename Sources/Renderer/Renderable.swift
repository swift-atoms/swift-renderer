/// A value with a statically associated renderer.
/// The renderer remains an independent operation with explicit input and context.
public protocol Renderable: ~Copyable {
    associatedtype Renderer: Renderer::Renderer.`Protocol` where Renderer.Input == Self
    static var renderer: Renderer { get }
}

extension Renderable where Self: ~Copyable {
    public borrowing func render(into context: inout Renderer.Context) throws(Renderer.Failure) {
        try Self.renderer.render(self, into: &context)
    }
}
