---
message: "unrecognized StrategyNumber: %d"
slug: unrecognized-strategynumber
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/ltree/_ltree_gist.c:540"
  - "postgres/contrib/ltree/ltree_gist.c:716"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:798"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:952"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:1233"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:1339"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:2095"
reproduced: false
---

# `unrecognized StrategyNumber: %d`

## What it means

Internal error. A `switch` over a `StrategyNumber` in an index operator class (for `ltree`/GiST and b-tree preprocessing) hit a value it does not handle — a spelling variant of the strategy-number guards. The placeholder is the number.

## When it happens

A custom or contrib operator class with inconsistent strategy handling, a mismatch between an index and its opclass, or index corruption. Ordinary queries on built-in opclasses do not trigger it.

## How to fix

Suspect the operator class in play, especially a custom or `ltree`/GiST one — its strategies must be consistent with the access method. For built-in opclasses, suspect corruption and try `REINDEX`. If it followed an extension upgrade, realign SQL and binary. Report reproducible cases.

## Example

*Illustrative* — an opclass with an unhandled strategy.

```text
ERROR:  unrecognized StrategyNumber: 15
```

## Related

- [unrecognized strategy number](./unrecognized-strategy-number.md)
- [invalid strategy number](./invalid-strategy-number.md)
