#if Document
extension Renderer.Document {

    public struct Group<Content> {

        public let content: Content

        public init(
            @Renderer.Document.Builder content: () -> Content
        ) {
            self.content = content()
        }
    }
}

extension Renderer.Document.Group: Renderer.Document.View where Content: Renderer.Document.View {

    public var body: Content { content }
}

extension Renderer.Document.Group: Sendable where Content: Sendable {}
#endif
