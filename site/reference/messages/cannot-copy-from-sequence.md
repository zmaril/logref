---
message: "cannot copy from sequence \"%s\""
slug: cannot-copy-from-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyto.c:836"
reproduced: false
---

# `cannot copy from sequence "%s"`

## What it means

A `COPY ... TO` named a sequence as its source. `COPY` reads rows from a table-like relation, and a sequence is not a row source that `COPY` can export. The placeholder is the sequence name.

## When it happens

It occurs when `COPY sequence TO ...` names a sequence.

## How to fix

Query the sequence's current value with `SELECT` and `currval`/`last_value` if you need it, rather than `COPY`. `COPY` operates on tables, not sequences.

## Example

*Illustrative* — COPY from a sequence.

```text
ERROR:  cannot copy from sequence "s"
```

## Related

- [cannot copy to sequence](./cannot-copy-to-sequence.md)
- [cannot copy from non-table relation](./cannot-copy-from-non-table-relation.md)
