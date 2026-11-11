#if Document
    extension Array: Renderer.Document.View where Element: Renderer.Document.View {

        public typealias Body = Never


        public static func _render(
            _ view: borrowing Self,
            context: inout Renderer.Document.Context
        ) {
            let marker = context._stackDepth
            let copy = copy view
            for element in copy {
                let pointer = UnsafeMutablePointer<Element>.allocate(capacity: 1)
                unsafe pointer.initialize(to: element)
                unsafe context._stack.append(
                    .render(
                        pointer: UnsafeMutableRawPointer(pointer),
                        thunk: Renderer.Document.Thunk(Element.self)
                    )
                )
            }
            context._reverseAbove(marker)
        }
    }
#endif
