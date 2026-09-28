#if Pair
import Renderer
import Testing

@Suite struct `Pair renderer contracts` {
    enum Failure: Error, Equatable { case stopped }

    struct DecoratedText: Renderer.`Protocol` {
        let prefix: String
        func render(_ input: borrowing String, into context: inout String) { context += prefix + input }
    }

    struct OwnedInput: ~Copyable { let value: String }
    struct OwnedRenderer: ~Copyable, Renderer.`Protocol` {
        borrowing func render(_ input: borrowing OwnedInput, into context: inout String) { context += input.value }
    }

    @Test func `A pair preserves operation order`() {
        var context = ""
        Pair(DecoratedText(prefix: "a"), DecoratedText(prefix: "b")).render("!", into: &context)
        #expect(context == "a!b!")
    }

    @Test func `Composition is associative`() {
        let a = DecoratedText(prefix: "a"), b = DecoratedText(prefix: "b"), c = DecoratedText(prefix: "c")
        var left = "", right = ""
        Pair(Pair(a, b), c).render("!", into: &left)
        Pair(a, Pair(b, c)).render("!", into: &right)
        #expect(left == right)
        #expect(left == "a!b!c!")
    }

    @Test func `Failure stops later effects and preserves earlier effects`() {
        let first = Renderer.Witness<Int, [Int], Failure> { input, context throws(Failure) in
            context.append(input)
            throw .stopped
        }
        let second = Renderer.Witness<Int, [Int], Failure> { input, context in context.append(input + 1) }
        var context: [Int] = []
        #expect(throws: Failure.stopped) {
            try Pair(first, second).render(1, into: &context)
        }
        #expect(context == [1])
    }

    @Test func `Noncopyable inputs and renderers are borrowed`() {
        let renderer = Pair(OwnedRenderer(), OwnedRenderer())
        let input = OwnedInput(value: "a")
        var context = ""
        renderer.render(input, into: &context)
        renderer.render(input, into: &context)
        #expect(context == "aaaa")
    }
}
#endif
