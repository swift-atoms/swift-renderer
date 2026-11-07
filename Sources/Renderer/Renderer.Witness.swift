extension Renderer {
    public struct Witness<Input: ~Copyable & ~Escapable, Context: ~Copyable & ~Escapable, Failure: Swift.Error>:
        Renderer.`Protocol`
    {
        private let operation: (_ input: borrowing Input, _ context: inout Context) throws(Failure) -> Void

        public init(
            _ operation: @escaping (_ input: borrowing Input, _ context: inout Context) throws(Failure) -> Void
        ) {
            self.operation = operation
        }

        public borrowing func render(
            _ input: borrowing Input,
            into context: inout Context
        ) throws(Failure) {
            try operation(input, &context)
        }
    }
}
