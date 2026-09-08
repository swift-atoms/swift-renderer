import Renderer
import Testing

@Suite struct `Renderers reuse operations across inputs and mutate supplied contexts` {
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

    @Test func `An operation is independent of an input instance`() {
        let renderer = DecoratedText(prefix: "[")
        var context = ""
        renderer.render("a", into: &context)
        renderer.render("b", into: &context)
        #expect(context == "[a[b")
    }

    @Test func `A target need not be text or bytes`() {
        var context: [Int] = []
        [Event(offset: 1), Event(offset: 4)].render(3, into: &context)
        let absent: Event? = nil
        absent.render(3, into: &context)
        #expect(context == [4, 7])
    }

    @Test func `Noncopyable inputs and renderers are borrowed`() {
        let renderer = OwnedRenderer()
        let input = OwnedInput(value: "a")
        var context = ""
        renderer.render(input, into: &context)
        renderer.render(input, into: &context)
        #expect(context == "aa")
    }

    @Test func `A witness can mutate a noncopyable context`() {
        let renderer = Renderer.Witness<Int, OwnedContext, Never> { input, context in context.count += input }
        var context = OwnedContext()
        renderer.render(3, into: &context)
        #expect(context.count == 3)
    }
}
