#if Document
    import Renderer
    import Renderer_Document_Test_Support
    import Testing

    enum `Renderer.Document.Listener Tests` {}

    extension `Renderer.Document.Listener Tests` {
        @Suite struct `Listeners reach the context and hand on events` {}
    }

    extension `Renderer.Document.Listener Tests`.`Listeners reach the context and hand on events` {
        @Test
        func `listen reaches the context`() {
            let state = Renderer.Document.Recording.State()
            let context = Renderer.Document.Context.recording(into: state)
            context.listen(Renderer.Document.Listener("click") { _ in })
            #expect(state.events == [.listen("click")])
        }

        @Test
        func `a context without a listener ignores listen`() {
            let context = Renderer.Document.Context(
                text: { _ in },
                break: .init(line: {}, thematic: {}, page: {}),
                image: { _, _ in },
                push: .init(block: { _, _ in }, inline: { _, _ in }, list: { _, _ in }, item: {}, link: { _ in }),
                pop: .init(block: {}, inline: {}, list: {}, item: {}, link: {})
            )
            var called = false
            context.listen(Renderer.Document.Listener("click") { _ in called = true })
            #expect(called == false)
        }

        @Test
        func `a listener hands its event to the handler`() {
            var seen = Renderer.Document.Event()
            let listener = Renderer.Document.Listener("input") { seen = $0 }
            listener.handle(Renderer.Document.Event(value: "typed", checked: true))
            #expect(seen.value == "typed")
            #expect(seen.checked)
        }
    }
#endif
