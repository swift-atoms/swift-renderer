#if Document
    extension Renderer.Document {

        public struct Listener {

            public let name: String

            public let handle: (Renderer.Document.Event) -> Void

            @inlinable
            public init(_ name: String, handle: @escaping (Renderer.Document.Event) -> Void) {
                self.name = name
                self.handle = handle
            }
        }
    }
#endif
