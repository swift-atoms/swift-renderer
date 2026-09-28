#if Document
extension Renderer.Document {

    public struct Empty: Renderer.Document.View, Sendable {

        public init() {}

        public typealias Body = Never

        public var body: Never { fatalError("Renderer.Document.Empty has no body; it is a leaf view") }

        public static func _render(
            _ view: borrowing Self,
            context: inout Renderer.Document.Context
        ) {}
    }
}
#endif
