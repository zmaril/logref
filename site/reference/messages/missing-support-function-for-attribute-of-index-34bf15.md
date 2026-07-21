---
message: "missing support function %d(%u,%u) for attribute %d of index \"%s\""
slug: missing-support-function-for-attribute-of-index-34bf15
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:2691"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:2713"
  - "postgres/src/backend/access/nbtree/nbtsearch.c:1421"
reproduced: false
---

# `missing support function %d(%u,%u) for attribute %d of index "%s"`

## What it means

Internal error. A btree index scan needed a numbered support function, identified by its argument types, for one of the indexed columns, and the operator family did not provide it for that type pair. The scan cannot proceed without it.

## When it happens

It should not occur for indexes with complete operator families. Reaching it points to an operator family that lacks a cross-type support function it should provide — usually a custom or extension-provided family — rather than to your query.

## How to fix

Inspect the operator family for the indexed column's type and the type in the comparison. Add the missing support function with `ALTER OPERATOR FAMILY`, or update the extension that supplies the family. Rebuild the index afterward to discard stale plans.

## Example

*Illustrative* — a missing cross-type support function.

```text
ERROR:  missing support function 1(23,20) for attribute 1 of index "my_idx"
```

## Related

- [missing support function for attribute of index](./missing-support-function-for-attribute-of-index-26abc2.md)
- [support function number is invalid for access method](./support-function-number-is-invalid-for-access-method.md)
