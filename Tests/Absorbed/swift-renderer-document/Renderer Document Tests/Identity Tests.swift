#if Document
    import Renderer
    import Renderer_Document_Test_Support
    import Testing

    enum `Renderer.Document.Identity Tests` {}

    extension `Renderer.Document.Identity Tests` {
        @Suite struct `Identities follow their ids and scope rows` {}
    }

    extension `Renderer.Document.Identity Tests`.`Identities follow their ids and scope rows` {
        @Test
        func `equal ids give equal identities`() {
            #expect(Renderer.Document.Identity(42) == Renderer.Document.Identity(42))
            #expect(Renderer.Document.Identity("row") == Renderer.Document.Identity("row"))
        }

        @Test
        func `different ids give different identities`() {
            #expect(Renderer.Document.Identity(1) != Renderer.Document.Identity(2))
        }

        @Test
        func `an identity scope reaches push and pop`() {
            let state = Renderer.Document.Recording.State()
            var context = Renderer.Document.Context.recording(into: state)
            context.open(push: .identity(Renderer.Document.Identity(7)), pop: .identity)
            context.render(TextLeaf("row"))
            #expect(
                state.events == [
                    .pushIdentity(Renderer.Document.Identity(7)),
                    .text("row"),
                ]
            )
        }

        @Test
        func `interpret routes identity actions`() {
            let state = Renderer.Document.Recording.State()
            var context = Renderer.Document.Context.recording(into: state)
            context.interpret([.push(.identity(Renderer.Document.Identity(3))), .pop(.identity)])
            #expect(state.events == [.pushIdentity(Renderer.Document.Identity(3)), .popIdentity])
        }

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
