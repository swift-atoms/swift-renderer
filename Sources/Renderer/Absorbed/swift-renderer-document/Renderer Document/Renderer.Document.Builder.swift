#if Document
extension Renderer.Document {

    @resultBuilder
    public enum Builder {

        public static func buildBlock<V>(_ v: V) -> V { v }

        public static func buildBlock<each Content>(
            _ content: repeat each Content
        ) -> Renderer.Document._Tuple<repeat each Content> {
            Renderer.Document._Tuple(repeat each content)
        }

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
