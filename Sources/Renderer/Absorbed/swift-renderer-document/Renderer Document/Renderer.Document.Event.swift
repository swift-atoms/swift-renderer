#if Document
    extension Renderer.Document {

        public struct Event: Sendable {

            public var value: String

            public var checked: Bool

            @inlinable
            public init(value: String = "", checked: Bool = false) {
                self.value = value
                self.checked = checked
            }
        }
    }
#endif
