#if Empty
public import Empty

extension Empty: Renderable where Element: Renderable & ~Copyable {
    public static var renderer: Renderer { Renderer() }
}
#endif
