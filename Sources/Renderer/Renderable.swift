public protocol Renderable: ~Copyable {
    associatedtype Renderer: Renderer::Renderer.`Protocol` & ~Copyable
    where Renderer.Input == Self, Renderer.Context: ~Copyable & ~Escapable
    static var renderer: Renderer { get }
}

extension Renderable where Self: ~Copyable {
    public borrowing func render(into context: inout Renderer.Context) throws(Renderer.Failure) {
        try Self.renderer.render(self, into: &context)
    }
}
