#if Document
extension Optional: Renderer.Document.View where Wrapped: Renderer.Document.View {

    public typealias Body = Never

    public var body: Never { fatalError("Optional has no body; rendering is performed by _render") }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        let copy = copy view
        switch copy {
        case .some(let wrapped): Wrapped._render(wrapped, context: &context)
        case .none: break
        }
    }
}
#endif
