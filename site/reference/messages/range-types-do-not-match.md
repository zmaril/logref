---
message: "range types do not match"
slug: range-types-do-not-match
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/rangetypes.c:590"
  - "postgres/src/backend/utils/adt/rangetypes.c:681"
  - "postgres/src/backend/utils/adt/rangetypes.c:719"
  - "postgres/src/backend/utils/adt/rangetypes.c:815"
  - "postgres/src/backend/utils/adt/rangetypes.c:858"
  - "postgres/src/backend/utils/adt/rangetypes.c:904"
  - "postgres/src/backend/utils/adt/rangetypes.c:945"
  - "postgres/src/backend/utils/adt/rangetypes.c:987"
  - "postgres/src/backend/utils/adt/rangetypes.c:1072"
  - "postgres/src/backend/utils/adt/rangetypes.c:1141"
  - "postgres/src/backend/utils/adt/rangetypes.c:1260"
  - "postgres/src/backend/utils/adt/rangetypes.c:1438"
  - "postgres/src/backend/utils/adt/rangetypes.c:2831"
  - "postgres/src/backend/utils/adt/rangetypes_gist.c:379"
reproduced: false
---

# `range types do not match`

## What it means

A range operation combined two range values of different range types (for example an `int4range` with a `numrange`), or a range function received a range whose element/subtype does not match what it expects. Ranges are strongly typed; operations require compatible range types.

## When it happens

Union/intersection/difference across mismatched range types, building a multirange from incompatible ranges, or a GiST/SP-GiST range operation with the wrong subtype. It also appears in custom range-type code that mixes types.

## How to fix

Ensure both operands are the same range type, casting explicitly if needed (for example cast an `int4range` to `numrange` before combining with one). Range operators only work within a single range type — there is no implicit cross-type coercion. Check the subtypes with `\dT` or `pg_range`.

## Example

*Illustrative* — combining two different range types.

```sql
SELECT int4range(1,5) + numrange(2,6);
```

Produces:

```text
ERROR:  range types do not match
```

## Related

- [unrecognized range strategy](./unrecognized-range-strategy.md)
- [cannot cast type %s to %s](./cannot-cast-type-to.md)
