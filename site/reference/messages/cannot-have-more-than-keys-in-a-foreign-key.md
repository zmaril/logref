---
message: "cannot have more than %d keys in a foreign key"
slug: cannot-have-more-than-keys-in-a-foreign-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13889"
reproduced: false
---

# `cannot have more than %d keys in a foreign key`

## What it means

A foreign-key definition listed more columns than a single key may contain. Postgres caps the number of columns in a key, and the foreign key exceeded it. The placeholder is the maximum key count.

## When it happens

It occurs when a `FOREIGN KEY` constraint names more columns than the limit (the maximum columns allowed in an index).

## How to fix

Reduce the number of columns in the foreign key. If the reference genuinely needs many columns, introduce a surrogate key on the referenced table and point the foreign key at that single column.

## Example

*Illustrative* — too many columns in a foreign key.

```text
ERROR:  cannot have more than 32 keys in a foreign key
```

## Related

- [cannot have more than columns in statistics](./cannot-have-more-than-columns-in-statistics.md)
- [cannot match partition key to index on column using non-equal operator](./cannot-match-partition-key-to-index-on-column-using-non-equal-operator.md)
