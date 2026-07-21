---
message: "invalid JsonbIteratorNext rc: %d"
slug: invalid-jsonbiteratornext-rc
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1171"
  - "postgres/src/backend/utils/adt/jsonb_op.c:286"
  - "postgres/src/backend/utils/adt/jsonb_op.c:329"
reproduced: false
---

# `invalid JsonbIteratorNext rc: %d`

## What it means

Internal error. Code iterating over a jsonb value received a return code from the iterator that is not one of the defined tokens. The jsonb iterator returns a small, fixed set of result codes, and this value was outside that set.

## When it happens

It should not occur when iterating well-formed jsonb. Reaching it points to a corrupt jsonb value or an internal inconsistency in the iterator, not to anything in your query.

## How to fix

Treat it as an internal-bug or corruption signal. Identify the jsonb value being processed, and if the same value reproduces it, restore it from a backup and report the case with the value that triggered it.

## Example

*Illustrative* — an unexpected iterator return code.

```text
ERROR:  invalid JsonbIteratorNext rc: 99
```

## Related

- [total size of jsonb object elements exceeds the maximum of bytes](./total-size-of-jsonb-object-elements-exceeds-the-maximum-of-bytes.md)
- [invalid internal value for enum](./invalid-internal-value-for-enum.md)
