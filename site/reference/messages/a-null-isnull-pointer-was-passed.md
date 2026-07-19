---
message: "a NULL isNull pointer was passed"
slug: a-null-isnull-pointer-was-passed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execUtils.c:1101"
  - "postgres/src/backend/executor/execUtils.c:1164"
reproduced: false
---

# `a NULL isNull pointer was passed`

## What it means

Internal error. A function-call support routine was invoked with a null pointer where it must receive a place to record whether the result is null. It is a consistency check in the function-manager interface, indicating a caller did not supply the required null-flag storage.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal or extension-level calling-convention error in how a function was invoked, not to your query.

## How to fix

Treat it as an internal or extension bug. If a custom extension function is involved, its calling convention may be wrong; note the function and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an internal calling-convention violation.

```text
ERROR:  a NULL isNull pointer was passed
```

## Related

- [attribute has wrong type](./attribute-has-wrong-type.md)
- [aggregate needs to have compatible input type and transition type](./aggregate-needs-to-have-compatible-input-type-and-transition-type.md)
