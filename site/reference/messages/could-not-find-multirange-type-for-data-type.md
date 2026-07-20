---
message: "could not find multirange type for data type %s"
slug: could-not-find-multirange-type-for-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/extension.c:3975"
  - "postgres/src/backend/commands/typecmds.c:4080"
  - "postgres/src/backend/utils/fmgr/funcapi.c:725"
reproduced: false
---

# `could not find multirange type for data type %s`

## What it means

Code needed the multirange type that corresponds to a given range/element type and could not find it. The placeholder names the data type. Each range type has an associated multirange type; the lookup expected one to exist for the type in play and did not find it.

## When it happens

Using multirange functionality with a range type that has no registered multirange type — for example a custom range type defined without its multirange, or catalog inconsistency.

## How to fix

Ensure the range type has a multirange type. Built-in range types all have one; for a custom `CREATE TYPE ... AS RANGE`, specify or allow the multirange type name so it is created. If a core type is involved, this indicates catalog inconsistency to investigate.

## Example

*Illustrative* — a range type without a multirange type.

```text
ERROR:  could not find multirange type for data type myrange
```

## Related

- [type is not a range type](./type-is-not-a-range-type.md)
- [argument declared is not a range type but type](./argument-declared-is-not-a-range-type-but-type.md)
