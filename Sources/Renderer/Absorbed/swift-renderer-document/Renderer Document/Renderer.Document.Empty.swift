#if Document
    extension Renderer.Document {
        public struct Empty: Renderer.Document.View, Sendable {
            public init() {}
        }
    }

    extension Renderer.Document.Empty {
        public typealias Body = Never

        public var body: Never { Self.unrendered }

        public static func _render(
            _ view: borrowing Self,
            context: inout Renderer.Document.Context
        ) {}
    }
#endif
