---
message: "array end of \"%s\" found in unexpected parse state: %d."
slug: array-end-of-found-in-unexpected-parse-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_dependencies.c:323"
  - "postgres/src/backend/utils/adt/pg_ndistinct.c:284"
reproduced: false
---

# `array end of "%s" found in unexpected parse state: %d.`

## What it means

Internal error. A parser reading the text representation of a statistics value reached the end of an array element while in a state where that token should not appear. It is the closing-token counterpart of the element-start consistency check.

## When it happens

It should not occur when reading server-produced statistics values. Reaching it points to a malformed or hand-edited value, or an internal inconsistency, rather than to normal query activity.

## How to fix

Treat it as an internal or data-integrity signal. Verify any imported or manually built statistics value is well-formed. Otherwise capture the operation and report it.

## Example

*Illustrative* — an unexpected closing token while parsing a statistics value.

```text
ERROR:  array end of "..." found in unexpected parse state: 2.
```

## Related

- [array element start of found in unexpected parse state](./array-element-start-of-found-in-unexpected-parse-state.md)
- [stxkind is not a 1-d char array](./stxkind-is-not-a-1-d-char-array.md)
