---
message: "could not determine which collation to use for string hashing"
slug: could-not-determine-which-collation-to-use-for-string-hashing
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/access/hash/hashfunc.c:278"
  - "postgres/src/backend/access/hash/hashfunc.c:333"
  - "postgres/src/backend/utils/adt/varchar.c:1001"
  - "postgres/src/backend/utils/adt/varchar.c:1057"
reproduced: false
---

# `could not determine which collation to use for string hashing`

## What it means

Hashing a string value (for a hash join, hash aggregate, or hash index) required a collation and Postgres could not determine which to use. The placeholder-free text means the operands' collations conflict or none could be derived. Collation matters because some providers hash equal-but-differently-encoded strings consistently.

## When it happens

A hash operation over text with an indeterminate collation — mixing columns of different explicit collations in a hashed grouping/join/DISTINCT, or a hash index on an expression whose collation is unresolved.

## How to fix

Attach an explicit `COLLATE` to the hashed expression so the collation is determinate — for example `GROUP BY col COLLATE "C"`. Resolve conflicting explicit collations among the operands before they reach the hash.

## Example

*Illustrative* — an indeterminate collation in a hashed grouping.

```sql
SELECT count(*) FROM t GROUP BY (a || b);  -- a, b have conflicting collations
```

## Related

- [could not determine which collation to use for function](./could-not-determine-which-collation-to-use-for-function.md)
- [invalid collation](./invalid-collation.md)
