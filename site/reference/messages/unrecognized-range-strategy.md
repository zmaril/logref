---
message: "unrecognized range strategy: %d"
slug: unrecognized-range-strategy
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:968"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:1030"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:1049"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:1084"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:1119"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:1138"
  - "postgres/src/backend/utils/adt/rangetypes_spgist.c:403"
  - "postgres/src/backend/utils/adt/rangetypes_spgist.c:653"
  - "postgres/src/backend/utils/adt/rangetypes_spgist.c:986"
reproduced: false
---

# `unrecognized range strategy: %d`

## What it means

Internal error. A range-type index (GiST or SP-GiST) support function was given a strategy number it does not implement. The placeholder is the strategy. Range operator classes map operators to strategy numbers; an unexpected one indicates an opclass/index inconsistency or a bug.

## When it happens

A mismatch between a range index and its operator class, a custom range opclass with inconsistent strategies, or index corruption. Ordinary range queries on built-in opclasses do not trigger it.

## How to fix

If a custom range operator class is involved, suspect it — verify its strategy numbers match the access method's expectations. For built-in opclasses, suspect index corruption and try `REINDEX`. Report reproducible cases against a specific opclass.

## Example

*Illustrative* — a range index with an unhandled strategy.

```text
ERROR:  unrecognized range strategy: 20
```

## Related

- [range types do not match](./range-types-do-not-match.md)
- [unrecognized strategy number](./unrecognized-strategy-number.md)
