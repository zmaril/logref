---
message: "invalid strategy number %d"
slug: invalid-strategy-number
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/brin/brin_bloom.c:646"
  - "postgres/src/backend/access/brin/brin_inclusion.c:462"
  - "postgres/src/backend/access/brin/brin_minmax.c:195"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:2648"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:2707"
  - "postgres/src/backend/partitioning/partprune.c:2954"
  - "postgres/src/backend/partitioning/partprune.c:3331"
reproduced: false
---

# `invalid strategy number %d`

## What it means

Internal error. An index operator class was given a strategy number it does not define — the same family of problem as "unrecognized strategy number", raised where the value is checked against the opclass's declared strategies. The placeholder is the strategy number.

## When it happens

A custom or contrib operator class with inconsistent strategy definitions, a mismatch between an index and its opclass, or a bug in access-method code. Ordinary queries on built-in opclasses do not trigger it.

## How to fix

Suspect the operator class, especially a custom one — its declared strategies and support code must agree. If it followed an extension upgrade, the SQL and binary may be out of sync (`ALTER EXTENSION ... UPDATE`). For built-in opclasses, suspect index corruption and try `REINDEX`. Report reproducible cases.

## Example

*Illustrative* — an opclass with an undefined strategy.

```text
ERROR:  invalid strategy number 12
```

## Related

- [unrecognized strategy number](./unrecognized-strategy-number.md)
- [missing operator in opfamily](./missing-operator-in-opfamily.md)
