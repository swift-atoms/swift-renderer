#if Document
import Renderer

extension Renderer.Document.Style.Font: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.size == rhs.size && lhs.weight == rhs.weight
    }
}

extension Renderer.Document.Style: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.font == rhs.font
            && lhs.color == rhs.color
            && lhs.margin == rhs.margin
    }
}

extension Renderer.Document.Semantic.Block: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.heading(let a), .heading(let b)): a == b
        case (.paragraph, .paragraph): true
        case (.blockquote, .blockquote): true
        case (.section, .section): true
        case (.pre, .pre): true
        case (.table, .table): true
        case (.row, .row): true
        case (.cell(let a), .cell(let b)): a == b
        default: false
        }
    }
}

extension Renderer.Document {
    public enum Recording {
        public final class State {
            public var events: [Event] = []
            public init() {}
        }

        public enum Event: Equatable, Sendable {
            case text(String)
            case `break`(Break)
            case image(source: String, alt: String)
            case setAttribute(name: String, value: String?)
            case addClass(String)
            case writeRaw([UInt8])
            case registerStyle(declaration: String, atRule: String?, selector: String?, pseudo: String?)
            case pushBlock(role: Renderer.Document.Semantic.Block?, style: Renderer.Document.Style)
            case popBlock
            case pushInline(role: Renderer.Document.Semantic.Inline?, style: Renderer.Document.Style)
            case popInline
            case pushList(kind: Renderer.Document.Semantic.List, start: Int?)
            case popList
            case pushItem
            case popItem
            case pushLink(destination: String)
            case popLink
            case pushAttributes
            case popAttributes
            case pushElement(tagName: String, isBlock: Bool, isVoid: Bool, isPreElement: Bool)
            case popElement(isBlock: Bool)
            case pushStyle
            case popStyle

            public enum Break: Equatable, Sendable {
                case line
                case thematic
                case page
            }
        }
    }
}

extension Renderer.Document.Context {
    public static func recording(into state: Renderer.Document.Recording.State) -> Self {
        .init(
            text: { state.events.append(.text($0)) },
            break: .init(
                line: { state.events.append(.break(.line)) },
                thematic: { state.events.append(.break(.thematic)) },
                page: { state.events.append(.break(.page)) }
            ),
            image: { state.events.append(.image(source: $0, alt: $1)) },
            push: .init(
                block: { state.events.append(.pushBlock(role: $0, style: $1)) },
                inline: { state.events.append(.pushInline(role: $0, style: $1)) },
                list: { state.events.append(.pushList(kind: $0, start: $1)) },
                item: { state.events.append(.pushItem) },
                link: { state.events.append(.pushLink(destination: $0)) },
                attributes: { state.events.append(.pushAttributes) },
                element: { tagName, isBlock, isVoid, isPreElement in
                    state.events.append(.pushElement(tagName: tagName, isBlock: isBlock, isVoid: isVoid, isPreElement: isPreElement))
                },
                style: { state.events.append(.pushStyle) }
            ),
            pop: .init(
                block: { state.events.append(.popBlock) },
                inline: { state.events.append(.popInline) },
                list: { state.events.append(.popList) },
                item: { state.events.append(.popItem) },
                link: { state.events.append(.popLink) },
                attributes: { state.events.append(.popAttributes) },
                element: { state.events.append(.popElement(isBlock: $0)) },
                style: { state.events.append(.popStyle) }
            ),
            setAttribute: { state.events.append(.setAttribute(name: $0, value: $1)) },
            addClass: { state.events.append(.addClass($0)) },
            writeRaw: { state.events.append(.writeRaw($0)) },
            registerStyle: { decl, atRule, sel, pseudo in
                state.events.append(.registerStyle(declaration: decl, atRule: atRule, selector: sel, pseudo: pseudo))
                return nil
            }
        )
    }
}

public struct TextLeaf: Renderer.Document.View, Sendable {
    public let value: String

    public init(_ value: String) { self.value = value }

    public typealias Body = Never
    public var body: Never { fatalError("body is never evaluated; rendering is performed by _render") }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        context.text(view.value)
    }
}

public struct LineBreakLeaf: Renderer.Document.View, Sendable {
    public init() {}

    public typealias Body = Never
    public var body: Never { fatalError("body is never evaluated; rendering is performed by _render") }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        context.`break`.line()
    }
}

public struct BlockWrapper<Content: Renderer.Document.View>: Renderer.Document.View {
    public let role: Renderer.Document.Semantic.Block?
    public let style: Renderer.Document.Style
    public let content: Content

    public init(
        role: Renderer.Document.Semantic.Block? = nil,
        style: Renderer.Document.Style = .empty,
        @Renderer.Document.Builder content: () -> Content
    ) {
        self.role = role
        self.style = style
        self.content = content()
    }

    public typealias Body = Never
    public var body: Never { fatalError("body is never evaluated; rendering is performed by _render") }

    public static func _render(
        _ view: borrowing Self,
        context: inout Renderer.Document.Context
    ) {
        context.open(
            push: .block(role: view.role, style: view.style),
            pop: .block
        )
        Content._render(view.content, context: &context)
    }
}

public func render<V: Renderer.Document.View & ~Copyable>(
    _ view: borrowing V
) -> [Renderer.Document.Recording.Event] {
    let state = Renderer.Document.Recording.State()
    var context = Renderer.Document.Context.recording(into: state)
    context.render(view)
    return state.events
}

public func buildContent<Content: Renderer.Document.View>(
    @Renderer.Document.Builder content: () -> Content
) -> Content {
    content()
}
#endif
