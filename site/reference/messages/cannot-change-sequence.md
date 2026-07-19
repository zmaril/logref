---
message: "cannot change sequence \"%s\""
slug: cannot-change-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1099"
reproduced: false
---

# `cannot change sequence "%s"`

## What it means

A data-modifying statement such as `INSERT`, `UPDATE`, or `DELETE` targeted a sequence. Sequences are not row-based tables; their value is advanced with sequence functions, not with data-modifying statements. The placeholder is the sequence name.

## When it happens

It occurs when a write statement names a sequence as its target relation.

## How to fix

Use `nextval`, `setval`, or `ALTER SEQUENCE` to change a sequence, not `INSERT`/`UPDATE`/`DELETE`. Sequences do not accept ordinary row modifications.

## Example

*Illustrative* — writing to a sequence.

```text
ERROR:  cannot change sequence "s"
```

## Related

- [cannot change materialized view](./cannot-change-materialized-view.md)
- [cannot change relation](./cannot-change-relation.md)
