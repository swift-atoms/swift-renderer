#if Document
extension Renderer.Document.Action {

    public enum Push: Sendable {
        case block(role: Renderer.Document.Semantic.Block?, style: Renderer.Document.Style)
        case inline(role: Renderer.Document.Semantic.Inline?, style: Renderer.Document.Style)
        case list(kind: Renderer.Document.Semantic.List, start: Int?)
        case item
        case link(destination: String)
        case attributes
        case element(tagName: String, isBlock: Bool, isVoid: Bool, isPreElement: Bool)
        case style
    }
}
#endif
