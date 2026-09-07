extension Renderer {
    public struct Witness<Input: ~Copyable & ~Escapable, Context: ~Copyable & ~Escapable, Failure: Swift.Error>:
        Renderer.`Protocol`
    {
        private let operation: (borrowing Input, inout Context) throws(Failure) -> Void

        public init(_ operation: @escaping (borrowing Input, inout Context) throws(Failure) -> Void) {
            self.operation = operation
        }

        public borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure) {
            try operation(input, &context)
        }
    }
}
