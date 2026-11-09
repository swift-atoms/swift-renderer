#if Document
    extension Renderer.Document {

        @resultBuilder
        public enum Builder {

            public static func buildBlock<V>(_ v: V) -> V { v }

            #if !hasFeature(Embedded)
                public static func buildBlock<each Content>(
                    _ content: repeat each Content
                ) -> Renderer.Document._Tuple<repeat each Content> {
                    Renderer.Document._Tuple(repeat each content)
                }
            #else
                // Embedded Swift cannot specialize generic calls on the elements of a parameter pack
                // (swift-atoms/swift-renderer#2), so a block of several children builds nested pairs instead,
                // rendered first, then second.
                public static func buildPartialBlock<V>(first: V) -> V { first }

                public static func buildPartialBlock<Accumulated, Next>(
                    accumulated: Accumulated,
                    next: Next
                ) -> Renderer.Document.Pair<Accumulated, Next> {
                    Renderer.Document.Pair(first: accumulated, second: next)
                }
            #endif

            public static func buildOptional<V>(_ v: V?) -> V? { v }

            public static func buildEither<First, Second>(
                first: First
            ) -> Renderer.Document.Conditional<First, Second> {
                .first(first)
            }

            public static func buildEither<First, Second>(
                second: Second
            ) -> Renderer.Document.Conditional<First, Second> {
                .second(second)
            }

            public static func buildArray<V>(_ components: [V]) -> [V] {
                components
            }
        }
    }
#endif
