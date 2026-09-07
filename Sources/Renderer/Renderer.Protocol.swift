extension Renderer {
    public protocol `Protocol`<Input, Context, Failure>: ~Copyable {
        associatedtype Input: ~Copyable & ~Escapable
        associatedtype Context: ~Copyable & ~Escapable
        associatedtype Failure: Swift.Error = Never

        borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure)
    }
}
