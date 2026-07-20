---
message: "cannot copy to sequence \"%s\""
slug: cannot-copy-to-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:834"
reproduced: false
---

# `cannot copy to sequence "%s"`

## What it means

A `COPY ... FROM` named a sequence as its target. Sequences are not row-based tables and their value is advanced with sequence functions, so `COPY FROM` cannot load into them. The placeholder is the sequence name.

## When it happens

It occurs when `COPY sequence FROM ...` names a sequence.

## How to fix

Use `setval` or `ALTER SEQUENCE` to set a sequence's value, not `COPY`. `COPY` operates on ordinary tables.

## Example

*Illustrative* — COPY into a sequence.

```text
ERROR:  cannot copy to sequence "s"
```

## Related

- [cannot copy from sequence](./cannot-copy-from-sequence.md)
- [cannot copy to non-table relation](./cannot-copy-to-non-table-relation.md)
