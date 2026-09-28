#if Document
extension Renderer.Document.Machine {

    @usableFromInline
    enum Frame {

        case closeScope(Renderer.Document.Action)
    }
}
#endif
