import Renderer
import Renderer_Standard_Library_Integration
import Testing

@Suite struct RendererContractTests {
    enum Failure: Error, Equatable { case stopped }

    struct DecoratedText: Renderer.`Protocol` {
        let prefix: String
        func render(_ input: borrowing String, into context: inout String) { context += prefix + input }
    }

    struct Event: Renderer.`Protocol` {
        let offset: Int
        func render(_ input: borrowing Int, into context: inout [Int]) { context.append(input + offset) }
    }

    struct OwnedInput: ~Copyable { let value: String }
    struct OwnedRenderer: ~Copyable, Renderer.`Protocol` {
        borrowing func render(_ input: borrowing OwnedInput, into context: inout String) { context += input.value }
    }
    struct OwnedContext: ~Copyable { var count = 0 }

    @Test func operationIsIndependentOfInputInstance() {
        let renderer = DecoratedText(prefix: "[")
        var context = ""
        renderer.render("a", into: &context)
        renderer.render("b", into: &context)
        #expect(context == "[a[b")
    }

    @Test func sequencePreservesOrder() {
        var context = ""
        Pair(DecoratedText(prefix: "a"), DecoratedText(prefix: "b")).render("!", into: &context)
        #expect(context == "a!b!")
    }

    @Test func compositionIsAssociative() {
        let a = DecoratedText(prefix: "a"), b = DecoratedText(prefix: "b"), c = DecoratedText(prefix: "c")
        var left = "", right = ""
        Pair(Pair(a, b), c).render("!", into: &left)
        Pair(a, Pair(b, c)).render("!", into: &right)
        #expect(left == right)
        #expect(left == "a!b!c!")
    }

    @Test func failureStopsLaterEffectsAndPreservesEarlierEffects() {
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

    @Test func targetDoesNotNeedToBeTextOrBytes() {
        var context: [Int] = []
        [Event(offset: 1), Event(offset: 4)].render(3, into: &context)
        let absent: Event? = nil
        absent.render(3, into: &context)
        #expect(context == [4, 7])
    }

    @Test func noncopyableInputAndRendererAreBorrowed() {
        let renderer = Pair(OwnedRenderer(), OwnedRenderer())
        let input = OwnedInput(value: "a")
        var context = ""
        renderer.render(input, into: &context)
        renderer.render(input, into: &context)
        #expect(context == "aaaa")
    }

    @Test func contextCanBeNoncopyable() {
        let renderer = Renderer.Witness<Int, OwnedContext, Never> { input, context in context.count += input }
        var context = OwnedContext()
        renderer.render(3, into: &context)
        #expect(context.count == 3)
    }
}
