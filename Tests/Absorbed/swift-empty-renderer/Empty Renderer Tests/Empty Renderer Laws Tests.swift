#if Empty
import Renderer
import Testing

@Suite struct `Empty renderer laws` {
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

    @Test func `Empty preserves a noncopyable context without constructing an element operation` () throws {
        let input = Empty<Content>()
        let renderer = Empty<Content>.Renderer()
        var context = Context()

        try renderer.render(input, into: &context)
        try renderer.render(input, into: &context)
        try input.render(into: &context)

        #expect(context.total == 7)
    }

    struct ScopedContent: Renderable {
        struct Renderer: Renderer::Renderer.`Protocol` {
            func render(_ input: borrowing ScopedContent, into context: inout EmptyScopedContext) {
                Issue.record("Empty invoked an element renderer")
                context.total += 1
            }
        }

        static var renderer: Renderer {
            Issue.record("Empty accessed the element renderer")
            return Renderer()
        }
    }

    @Test func `Empty forwards a scoped context unchanged` () {
        let values = [3]
        var context = EmptyScopedContext(values.span)
        let input = Empty<ScopedContent>()

        Empty<ScopedContent>.Renderer().render(input, into: &context)
        input.render(into: &context)

        #expect(context.total == 7)
        #expect(context.values[0] == 3)
    }
}

struct EmptyScopedContext: ~Copyable, ~Escapable {
    let values: Span<Int>
    var total = 7

    @_lifetime(copy values)
    init(_ values: Span<Int>) { self.values = values }
}
#endif
