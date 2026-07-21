---
message: "byval datum but length = %zu"
slug: byval-datum-but-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:629"
reproduced: false
---

# `byval datum but length = %zu`

## What it means

Code that packages a value found it flagged as pass-by-value but carrying a length that a pass-by-value datum cannot have. The placeholder is the length. Pass-by-value types fit in a machine word, so an inconsistent length is an internal invariant violation.

## When it happens

It is a can't-happen guard in datum handling. It would surface from a type definition or an extension that describes a type inconsistently, not from ordinary queries.

## How to fix

This is not caused by normal SQL. If an extension defines the type involved, its by-value flag and length disagree; report it to the extension author. In core it indicates a bug worth reporting with the server version.

## Example

*Illustrative* — the datum-length guard.

```text
ERROR:  byval datum but length = 16
```

## Related

- [byte ordering mismatch](./byte-ordering-mismatch.md)
- [cannot accept a value of a shell type](./cannot-accept-a-value-of-a-shell-type.md)
