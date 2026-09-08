import Renderer
import Testing

@Suite struct `Renderers preserve borrowed input and context ownership` {
    struct Input: ~Copyable { let value: Int }
    struct Context: ~Copyable { var total = 0 }

    struct Operation: ~Copyable, Renderer.`Protocol` {
        borrowing func render(_ input: borrowing Input, into context: inout Context) {
            context.total += input.value
        }
    }

    struct Content: ~Copyable, Renderable {
        let value: Int

        struct Renderer: ~Copyable, Renderer::Renderer.`Protocol` {
            borrowing func render(_ input: borrowing Content, into context: inout Context) {
                context.total += input.value
            }
        }

        static var renderer: Renderer { Renderer() }
    }

    @Test func `Optional noncopyable operations can be borrowed repeatedly` () {
        let present: Operation? = Operation()
        let absent: Operation? = nil
        let input = Input(value: 3)
        var context = Context()

        present.render(input, into: &context)
        present.render(input, into: &context)
        absent.render(input, into: &context)

        #expect(context.total == 6)
    }

    @Test func `Renderable borrows noncopyable values through noncopyable associated operations` () {
        let content = Content(value: 4)
        var context = Context()

        content.render(into: &context)
        content.render(into: &context)

        #expect(context.total == 8)
    }

    @Test func `Array and optional adapters preserve noncopyable inputs and contexts` () {
        let witness = Renderer.Witness<Input, Context, Never> { input, context in
            context.total += input.value
        }
        let input = Input(value: 3)
        var context = Context()
        let optional: Renderer.Witness<Input, Context, Never>? = witness

        [witness, witness].render(input, into: &context)
        optional.render(input, into: &context)

        #expect(context.total == 9)
        #expect(input.value == 3)
    }

    @Test func `Array and optional adapters accept scoped inputs and contexts` () {
        let values = [3, 7]
        let input = values.span
        var context = ScopedContext(values.span)
        let witness = Renderer.Witness<Span<Int>, ScopedContext, Never> { input, context in
            context.total += input[0] + context.values[1]
        }
        let optional: Renderer.Witness<Span<Int>, ScopedContext, Never>? = witness

        [witness, witness].render(input, into: &context)
        optional.render(input, into: &context)

        #expect(context.total == 30)
        #expect(input[0] == 3)
    }

    struct ScopedContent: Renderable {
        let value: Int

        struct Renderer: Renderer::Renderer.`Protocol` {
            func render(_ input: borrowing ScopedContent, into context: inout ScopedContext) {
                context.total += input.value + context.values[0]
            }
        }

        static var renderer: Renderer { Renderer() }
    }

    @Test func `Renderable forwards a scoped context to its associated operation` () {
        let values = [3]
        var context = ScopedContext(values.span)
        let content = ScopedContent(value: 4)

        content.render(into: &context)
        content.render(into: &context)

        #expect(context.total == 14)
    }
}

struct ScopedContext: ~Copyable, ~Escapable {
    let values: Span<Int>
    var total = 0

    @_lifetime(copy values)
    init(_ values: Span<Int>) { self.values = values }
}
