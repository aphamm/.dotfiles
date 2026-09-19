# Design red flags

Screen every interface — proposed or existing — against these four flags. Each is a labelled heuristic, a reason to revise the shape, never a hard violation. (Ousterhout, _A Philosophy of Software Design_, ch. 4–7; via pstack `architect`.)

## Shallow module

A large interface hiding little complexity — depth-as-leverage near 1. Don't confuse a deep module with a deep call chain: a chain scatters understanding across layers; a deep module concentrates capability behind one interface.

Detect:

- Callers coordinate several methods to complete one operation.
- Public options expose internal stages or implementation choices.
- Learning the interface does not save the caller from learning the implementation.

Fix: collapse the coordinated methods into one operation; move the exposed choices inside. Then re-run the deletion test.

## Information leakage

One internal decision — a representation, policy, or protocol detail — appears in more than one module, so changing it requires coordinated edits. Public re-exports of transport or wire types are leakage.

Detect: ask "if this decision changes, how many modules edit?" More than one is the flag. Storage schemas, framework objects, and protocol types visible in an interface are the common carriers.

Fix: parse external data into domain types behind the interface; keep the schema, framework object, or wire type private to one adapter.

## Temporal decomposition

Modules organized by execution order (load → validate → transform → save) instead of the knowledge they own. The stages repeat one representation and its invariants across several seams.

Detect: stage-named modules that all import the same representation; an invariant enforced in more than one stage.

Fix: group code around domain knowledge and ownership. Methods that run at different times still belong to one module when they protect the same decisions.

## Pass-through method

A method that forwards the same arguments to another method with the same shape — a layer that hides nothing. This is the deletion test failing at method scale.

Detect: same signature above and below; deleting the method would change no caller's knowledge.

Fix: remove it, or move responsibility to the module that can complete the operation. Keep a forwarding seam only when it adds policy, adaptation, or a distinct interface.
