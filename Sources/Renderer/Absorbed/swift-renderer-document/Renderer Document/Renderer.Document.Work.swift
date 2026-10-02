#if Document
extension Renderer.Document {

    @usableFromInline
    @unsafe enum Work {
        case render(pointer: UnsafeMutableRawPointer, thunk: Renderer.Document.Thunk)
        case action(Renderer.Document.Action)
        case frame(Renderer.Document.Machine.Frame)
    }
}
#endif
