#if Document
    extension Renderer.Document {

        public protocol Primitive: View, ~Copyable where Body == Never {}
    }

    extension Renderer.Document.Primitive where Self: ~Copyable {

        public var body: Never { fatalError("A primitive view has no body; rendering is performed by _render") }
    }
#endif
