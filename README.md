# swift-renderer

Use this package when a value must be written into a target the caller owns, such as a string, a byte buffer, an event log, or a `~Copyable` or `~Escapable` context, by an operation kept apart from the value. Start from ``Renderer.`Protocol` `` for the operation, `Renderable` for a type that names its own operation, and `Renderer.Witness` for an operation made from a closure. With the Document trait, use `Renderer.Document.View` and `Renderer.Document.Context` to build a document from views and replay it to a backend as push, pop, text and break calls. In tests, `Renderer.Document.Recording` (from the `Renderer Document Test Support` product) records that call stream.

## Laws

- `Swift.Array`, `Swift.Optional` and `Pair.Pair<First, Second>` run their operations in order (array index, then `first` before `second`). Each operation gets the same borrowed input and the same context.
- Pair composition is associative. An empty array or a `nil` optional is a left and right identity. Regrouping pairs, or flattening them into an array, gives the same effects and the same failure.
- The first failure stops a composition: later operations do not run. Effects already written to the context stay there, because nothing is rolled back.
- A present optional behaves exactly like the operation it wraps, failure included.
- `Renderer.Witness` calls its closure exactly once per `render`.
- `Empty.Empty<Element>.Renderer` never writes and never throws. It never reads `Element.renderer`, so the element's operation is never constructed or invoked. Composed with a pair over the same input, it is an identity.
- `Renderer.Document.Context.render(_:)` emits in source order: builder statements, `Swift.Array` and `Renderer.Document._Tuple` elements, then `Renderer.Document.Pair` with `first` before `second`. `Renderer.Document.Conditional` emits only the chosen branch, and a `nil` optional emits nothing. `Renderer.Document.Group` and `Renderer.Document.Empty` add no events of their own.
- `Renderer.Document.Context.open(push:pop:)` emits the push immediately. It emits the matching pop after all content the view schedules after it, and before the next sibling renders.
- Rendering runs from an explicit work stack, not from recursion. A copyable view is copied into a heap cell when it is scheduled. Its `body` is evaluated when the view is taken off the stack, once per render. Noncopyable views are borrowed and render in place.
- A view whose `Body` is `Never` must implement `_render`. For a copyable view, the default `_render` evaluates `body`, and that traps.
