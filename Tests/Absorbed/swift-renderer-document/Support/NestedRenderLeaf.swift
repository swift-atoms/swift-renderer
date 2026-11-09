#if Document
    import Renderer

    /// A leaf whose `_render` runs a complete nested `Context.render(_:)`
    /// and then writes `tail`, so a test can see whether the nested render
    /// left the outer render's pending work alone.
    public struct NestedRenderLeaf<Inner: Renderer.Document.View>: Renderer.Document.View {
        public let inner: Inner
        public let tail: String

        public init(tail: String, @Renderer.Document.Builder inner: () -> Inner) {
            self.inner = inner()
            self.tail = tail
        }

        public typealias Body = Never
        public var body: Never { fatalError("body is never evaluated; rendering is performed by _render") }

        public static func _render(
            _ view: borrowing Self,
            context: inout Renderer.Document.Context
        ) {
            context.render(view.inner)
            context.text(view.tail)
        }
    }
#endif
