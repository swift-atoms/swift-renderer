#if Document
extension Renderer.Document {

    public protocol View: ~Copyable {
        associatedtype Body: View & ~Copyable
        @Builder var body: Body { get }

        static func _render(
            _ view: borrowing Self,
            context: inout Context
        )
    }
}

extension Renderer.Document.View where Self: Copyable {

    @inlinable
    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        let viewCopy = copy view
        let pointer = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        unsafe pointer.initialize(to: viewCopy)
        unsafe context._stack.append(
            .render(
                pointer: UnsafeMutableRawPointer(pointer),
                thunk: Renderer.Document.Thunk(view: Self.self)
            )
        )
    }
}

extension Never: Renderer.Document.View {

    public typealias Body = Never

    public var body: Never { fatalError("Never has no body") }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {}
}
#endif
