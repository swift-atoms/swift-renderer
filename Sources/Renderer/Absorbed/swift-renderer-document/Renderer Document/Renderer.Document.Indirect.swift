#if Document
extension Renderer.Document {

    public final class Indirect<Content: ~Copyable> {

        public let value: Content

        @inlinable
        public init(_ value: consuming Content) { self.value = value }
    }
}

extension Renderer.Document.Indirect: @unsafe @unchecked Sendable where Content: Sendable & ~Copyable {}
#endif
