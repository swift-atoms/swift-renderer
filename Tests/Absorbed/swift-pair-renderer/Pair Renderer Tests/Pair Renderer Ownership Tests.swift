#if Pair
import Renderer
import Testing

@Suite struct `Pair renderer ownership contracts` {
    struct Input: ~Copyable { let value: Int }
    struct Context: ~Copyable { var total = 0 }

    @Test func `Paired witnesses preserve noncopyable inputs and contexts` () {
        let witness = Renderer.Witness<Input, Context, Never> { input, context in
            context.total += input.value
        }
        let input = Input(value: 3)
        var context = Context()

        Pair(witness, witness).render(input, into: &context)

        #expect(context.total == 6)
        #expect(input.value == 3)
    }

    @Test func `Paired witnesses accept scoped inputs and contexts` () {
        let values = [3, 7]
        let input = values.span
        var context = PairScopedContext(values.span)
        let witness = Renderer.Witness<Span<Int>, PairScopedContext, Never> { input, context in
            context.total += input[0] + context.values[1]
        }

        Pair(witness, witness).render(input, into: &context)

        #expect(context.total == 20)
        #expect(input[0] == 3)
    }
}

struct PairScopedContext: ~Copyable, ~Escapable {
    let values: Span<Int>
    var total = 0

    @_lifetime(copy values)
    init(_ values: Span<Int>) { self.values = values }
}
#endif
