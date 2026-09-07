# Renderer

Renderer represents a rendering operation independently of the input it presents, following the operation/witness pattern of Parser and Serializer.

`Renderer.Protocol<Input, Context, Failure>` requires `render(_:into:)`. It borrows input and updates an explicit target context. `Renderer.Witness` implements the operation through a closure:

```swift
let renderer = Renderer.Witness<Int, String, Never> { input, context in
    context += String(input)
}
var output = ""
renderer.render(42, into: &output)
```

`Renderable` associates an input type with a renderer through an associated Renderer type and static renderer value. Its render(into:) convenience delegates to that operation. Renderer and renderable input remain separate concepts.

A Pair of renderers with matching input, context and failure types presents the same input left to right. Typed failure stops later effects but does not roll back earlier context mutations. Transactional/speculative behavior belongs to the context or a higher-level composition. Inputs and contexts may be noncopyable/non-escapable; operations may be noncopyable.

The core owns no empty rendering type and does not depend on Empty. The swift-empty-renderer molecule supplies Empty.Renderer and makes Empty renderable. Array and Optional operation adapters belong to Renderer Standard Library Integration; conformances on the atom's own types belong in core.

This contract requires neither a document model nor a storage encoding. Its context may target text, drawing commands, terminal operations or another presentation medium. Document roles, markup, styling, layout breaks, the view DSL and work-stack execution are preserved separately in swift-renderer-document as Renderer.Document; adapting that framework and higher consumers remains deferred.
