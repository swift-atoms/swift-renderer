#if Document
    extension Renderer.Document {

        public struct Identity: Hashable, Sendable {

            public let hash: Int

            @inlinable
            public init<ID: Hashable>(_ id: ID) {
                self.hash = id.hashValue
            }
        }
    }
#endif
