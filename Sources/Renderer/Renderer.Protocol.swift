extension Renderer {
    /// An operation that presents input by updating a caller-selected target context.
    /// Earlier context mutations remain when an operation fails; transactions and
    /// rollback belong to a context or a higher-level composition.
    public protocol `Protocol`<Input, Context, Failure>: ~Copyable {
        associatedtype Input: ~Copyable & ~Escapable
        associatedtype Context: ~Copyable & ~Escapable
        associatedtype Failure: Swift.Error = Never

        borrowing func render(_ input: borrowing Input, into context: inout Context) throws(Failure)
    }
}
