#if Document
extension Renderer.Document {

    public struct Pair<First: ~Copyable, Second: ~Copyable>: ~Copyable {

        public let first: First

        public let second: Second

        public init(first: consuming First, second: consuming Second) {
            self.first = first
            self.second = second
        }
    }
}

extension Renderer.Document.Pair: Renderer.Document.View
where First: Renderer.Document.View & ~Copyable, Second: Renderer.Document.View & ~Copyable {

    public typealias Body = Never

    public var body: Never {
        fatalError("Renderer.Document.Pair has no body; rendering is performed by _render")
    }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        let marker = context._stackDepth
        First._render(view.first, context: &context)
        context._drain(above: marker)
        Second._render(view.second, context: &context)
        context._drain(above: marker)
    }
}

extension Renderer.Document.Pair: Copyable where First: Copyable, Second: Copyable {}
extension Renderer.Document.Pair: Sendable where First: Sendable & Copyable, Second: Sendable & Copyable {}
#endif
