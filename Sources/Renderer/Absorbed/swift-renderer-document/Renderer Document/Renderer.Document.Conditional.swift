#if Document
extension Renderer.Document {

    public enum Conditional<First: ~Copyable, Second: ~Copyable>: ~Copyable {
        case first(First)
        case second(Second)
    }
}

extension Renderer.Document.Conditional: Renderer.Document.View
where First: Renderer.Document.View & ~Copyable, Second: Renderer.Document.View & ~Copyable {

    public typealias Body = Never

    public var body: Never {
        fatalError("Renderer.Document.Conditional has no body; rendering is performed by _render")
    }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        switch view {
        case .first(let f): First._render(f, context: &context)
        case .second(let s): Second._render(s, context: &context)
        }
    }
}

extension Renderer.Document.Conditional: Copyable where First: Copyable, Second: Copyable {}
extension Renderer.Document.Conditional: Sendable
where First: Sendable & Copyable, Second: Sendable & Copyable {}
#endif
