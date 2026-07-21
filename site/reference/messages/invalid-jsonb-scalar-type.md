---
message: "invalid jsonb scalar type"
slug: invalid-jsonb-scalar-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:924"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1467"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1516"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1546"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1586"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1990"
reproduced: false
---

# `invalid jsonb scalar type`

## What it means

Internal error. The `jsonb` serializer walked its in-memory tree and reached a scalar node whose type tag was none of the ones it knows (null, string, numeric, bool). The placeholder-free text names no value because the tag itself is invalid, which means the tree was built wrong or corrupted in memory.

## When it happens

It should never happen from ordinary `jsonb` values. It points to a bug in code that constructs `jsonb` containers directly, or to memory corruption.

## How to fix

Treat it as an internal bug. If it is reproducible, capture the input and the operation and report it. If it appears with other corruption symptoms, run hardware and memory checks.

## Example

*Illustrative* — emitted internally by the jsonb code path.

```text
ERROR:  invalid jsonb scalar type
```

## Related

- [unexpected jsonb token](./unexpected-jsonb-token.md)
- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
