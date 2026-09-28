#if Pair
import Renderer
import Testing

@Suite struct `Empty operations in pair composition` {
    enum Failure: Error, Equatable { case stopped }

    struct Context: ~Copyable { var total = 7 }

    struct Content: ~Copyable, Renderable {
        struct Renderer: ~Copyable, Renderer::Renderer.`Protocol` {
            init() { Issue.record("Empty constructed an element renderer") }

            borrowing func render(_ input: borrowing Content, into context: inout Context) throws(Failure) {
                Issue.record("Empty invoked an element renderer")
                context.total += 1
                throw .stopped
            }
        }

        static var renderer: Renderer {
            Issue.record("Empty accessed the element renderer")
            return Renderer()
        }
    }

    @Test func `Empty is a left and right identity for operations on empty input` () throws {
        let empty = Empty<Content>.Renderer()
        let effect = Renderer.Witness<Empty<Content>, Context, Failure> { _, context in
            context.total *= 2
        }
        let input = Empty<Content>()
        var left = Context(), right = Context()

        try Pair(empty, effect).render(input, into: &left)
        try Pair(effect, empty).render(input, into: &right)

        #expect(left.total == 14)
        #expect(right.total == left.total)
    }

    @Test func `Empty preserves the failure type and earlier effects in composition` () {
        let empty = Empty<Content>.Renderer()
        let effect = Renderer.Witness<Empty<Content>, Context, Failure> { _, context throws(Failure) in
            context.total += 1
            throw .stopped
        }
        let input = Empty<Content>()
        var left = Context(), right = Context()

        do {
            try Pair(empty, effect).render(input, into: &left)
            Issue.record("Expected a rendering failure")
        } catch {
            let failure: Failure = error
            #expect(failure == .stopped)
        }
        do {
            try Pair(effect, empty).render(input, into: &right)
            Issue.record("Expected a rendering failure")
        } catch {
            let failure: Failure = error
            #expect(failure == .stopped)
        }

        #expect(left.total == 8)
        #expect(right.total == left.total)
    }
}
#endif
