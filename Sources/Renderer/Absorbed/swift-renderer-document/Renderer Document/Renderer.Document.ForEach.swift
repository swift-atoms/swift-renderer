#if Document
    extension Renderer.Document {

        public struct ForEach<Data: Swift.Collection, ID: Hashable, Content: Renderer.Document.View> {

            public let data: Data

            public let id: (Data.Element) -> ID

            public let content: (Data.Element) -> Content

            public init(
                _ data: Data,
                id: @escaping (Data.Element) -> ID,
                @Renderer.Document.Builder content: @escaping (Data.Element) -> Content
            ) {
                self.data = data
                self.id = id
                self.content = content
            }
        }
    }

    extension Renderer.Document.ForEach: Renderer.Document.View {

        public typealias Body = Never

        public static func _render(
            _ view: borrowing Self,
            context: inout Renderer.Document.Context
        ) {
            for element in view.data {
                context.interpret(.push(.identity(Renderer.Document.Identity(view.id(element)))))
                context.render(view.content(element))
                context.interpret(.pop(.identity))
            }
        }
    }

    extension Renderer.Document.ForEach: Renderer.Document.Primitive {}
#endif
