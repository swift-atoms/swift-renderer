#if Empty
import Renderer
import Testing

@Suite struct `Empty rendering contracts` {
    enum Failure: Error { case unexpected }

    struct Content: Renderable {
        struct Renderer: Renderer::Renderer.`Protocol` {
            init() { Issue.record("Empty constructed an element renderer") }

            func render(_ input: borrowing Content, into context: inout [Int]) throws(Failure) {
                context.append(99)
                throw .unexpected
            }
        }
        static var renderer: Renderer {
            Issue.record("Empty accessed the element renderer")
            return Renderer()
        }
    }

    struct OwnedContent: ~Copyable, Renderable {
        struct Renderer: ~Copyable, Renderer::Renderer.`Protocol` {
            func render(_ input: borrowing OwnedContent, into context: inout String) { context += "unexpected" }
        }
        static var renderer: Renderer { Renderer() }
    }

    @Test func `An empty operation leaves the context unchanged`() throws {
        var context = [1, 2]
        try Empty<Content>.Renderer().render(Empty<Content>(), into: &context)
        #expect(context == [1, 2])
    }

    @Test func `An empty value uses its associated renderer`() throws {
        var context = [3]
        try Empty<Content>().render(into: &context)
        #expect(context == [3])
    }

    @Test func `Empty supports noncopyable element types`() {
        let empty = Empty<OwnedContent>()
        var context = "before"
        empty.render(into: &context)
        empty.render(into: &context)
        #expect(context == "before")
    }
}
#endif
