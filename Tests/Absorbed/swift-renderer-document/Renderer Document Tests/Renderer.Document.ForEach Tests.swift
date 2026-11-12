#if Document
    import Renderer
    import Renderer_Document_Test_Support
    import Testing

    enum `Renderer.Document.ForEach Tests` {}

    extension `Renderer.Document.ForEach Tests` {
        @Suite struct `Each element renders in its own identity scope` {}
    }

    extension `Renderer.Document.ForEach Tests`.`Each element renders in its own identity scope` {
        @Test
        func `rows render in order, each inside its identity`() {
            let state = Renderer.Document.Recording.State()
            var context = Renderer.Document.Context.recording(into: state)
            context.render(Renderer.Document.ForEach(["a", "b"], id: { $0 }) { TextLeaf($0) })
            #expect(
                state.events == [
                    .pushIdentity(Renderer.Document.Identity("a")),
                    .text("a"),
                    .popIdentity,
                    .pushIdentity(Renderer.Document.Identity("b")),
                    .text("b"),
                    .popIdentity,
                ]
            )
        }

        @Test
        func `an empty collection renders nothing`() {
            let state = Renderer.Document.Recording.State()
            var context = Renderer.Document.Context.recording(into: state)
            context.render(Renderer.Document.ForEach([String](), id: { $0 }) { TextLeaf($0) })
            #expect(state.events.isEmpty)
        }
    }
#endif
