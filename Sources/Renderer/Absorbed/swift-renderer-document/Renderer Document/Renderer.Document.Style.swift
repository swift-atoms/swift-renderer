#if Document
    extension Renderer.Document {
        public struct Style: Sendable {
            public var font: Font

            public var color: Color?

            public var margin: Float?

            public init(
                font: Font = Font(),
                color: Color? = nil,
                margin: Float? = nil
            ) {
                self.font = font
                self.color = color
                self.margin = margin
            }
        }
    }

extension Renderer.Document.Style {
        public struct Font: Sendable {
            public var size: Float?

            public var weight: Weight?

            public init(size: Float? = nil, weight: Weight? = nil) {
                self.size = size
                self.weight = weight
            }
        }

        public enum Color: Sendable { case black, red, blue, gray }

        public static let empty = Self()
}

extension Renderer.Document.Style.Font {
        public enum Weight: Sendable { case normal, bold }
}
#endif
