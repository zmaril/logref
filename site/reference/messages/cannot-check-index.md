---
message: "cannot check index \"%s\""
slug: cannot-check-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/amcheck/verify_common.c:184"
reproduced: false
---

# `cannot check index "%s"`

## What it means

An index-verification routine — from amcheck or a related check — could not process the named index because it is not of a kind the check supports, or is not in a state it can inspect. The placeholder is the index name.

## When it happens

It occurs when running an index integrity check against an index whose access method or condition the checker does not handle.

## How to fix

Run the check only on index types it supports, and make sure the index is valid and fully built. Consult the amcheck documentation for which access methods and states can be verified.

## Example

*Illustrative* — checking an unsupported index.

```text
ERROR:  cannot check index "t_idx"
```

## Related

- [cannot check relation](./cannot-check-relation.md)
- [cannot cluster on invalid index](./cannot-cluster-on-invalid-index-3b22e6.md)
