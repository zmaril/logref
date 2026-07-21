---
message: "type %u is not a range type"
slug: type-is-not-a-range-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/rangetypes.c:339"
  - "postgres/src/backend/utils/adt/rangetypes.c:1272"
  - "postgres/src/backend/utils/adt/rangetypes.c:1946"
  - "postgres/src/backend/utils/adt/rangetypes.c:3036"
reproduced: false
---

# `type %u is not a range type`

## What it means

Internal error. Code looked up a type by OID expecting a range type and got one that is not a range. The placeholder is the type OID. Range-specific machinery (range functions, multirange support) checks that the type it was handed really is a range; a mismatch is a consistency guard.

## When it happens

It does not arise from ordinary SQL, which reports a by-name datatype error instead. Reaching this internal form points to a bug in code that constructs range operations, or a corrupted `pg_range`/`pg_type` linkage.

## How to fix

Treat it as an internal bug. If it correlates with a custom range type or an extension, suspect that definition. Capture the operation and report it; a damaged `pg_range` row would need catalog investigation.

## Example

*Illustrative* — emitted internally by range code.

```text
ERROR:  type 16450 is not a range type
```

## Related

- [could not find multirange type for data type](./could-not-find-multirange-type-for-data-type.md)
- [argument declared is not a range type but type](./argument-declared-is-not-a-range-type-but-type.md)
