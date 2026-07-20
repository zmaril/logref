---
message: "array element start of \"%s\" found in unexpected parse state: %d."
slug: array-element-start-of-found-in-unexpected-parse-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_dependencies.c:439"
  - "postgres/src/backend/utils/adt/pg_ndistinct.c:381"
reproduced: false
---

# `array element start of "%s" found in unexpected parse state: %d.`

## What it means

Internal error. A parser reading the text representation of a statistics value (extended-statistics dependencies or n-distinct data) reached the start of an array element while in a state where that token should not appear. It is a consistency check in that specialized value parser.

## When it happens

It should not occur when reading values written by the server. Reaching it points to a malformed or hand-edited statistics value, or an internal inconsistency, rather than to normal query activity.

## How to fix

Treat it as an internal or data-integrity signal. If a statistics value was imported or manually constructed, verify it is well-formed. Otherwise capture the operation and report it, since server-produced values should not trigger it.

## Example

*Illustrative* — an unexpected token while parsing a statistics value.

```text
ERROR:  array element start of "..." found in unexpected parse state: 3.
```

## Related

- [array end of found in unexpected parse state](./array-end-of-found-in-unexpected-parse-state.md)
- [stxkind is not a 1-d char array](./stxkind-is-not-a-1-d-char-array.md)
