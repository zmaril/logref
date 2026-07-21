---
message: "object end of \"%s\" found in unexpected parse state: %d."
slug: object-end-of-found-in-unexpected-parse-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_dependencies.c:151"
  - "postgres/src/backend/utils/adt/pg_ndistinct.c:138"
reproduced: false
---

# `object end of "%s" found in unexpected parse state: %d.`

## What it means

Internal error. A JSON parser callback reported the end of an object while the parser's state machine was in a state where that event should not occur. The placeholders are the key/label and the numeric state. It is a consistency guard in JSON parsing.

## When it happens

It fires from the SAX-style JSON parser used by JSON processing functions when its event sequence is internally inconsistent. Well-formed and even malformed JSON normally produce a clear syntax error instead; reaching this guard points to an internal bug or a custom parse handler.

## How to fix

This is a can't-happen guard. If a custom C function uses the JSON parse callbacks, review its state handling. Otherwise capture the input and the function used and report a reproducible case.

## Example

*Illustrative* — an object-end event in a bad parse state.

```text
ERROR:  object end of "a" found in unexpected parse state: 3.
```

## Related

- [object start of found in unexpected parse state](./object-start-of-found-in-unexpected-parse-state.md)
- [invalid JsonFuncExpr op](./invalid-jsonfuncexpr-op.md)
