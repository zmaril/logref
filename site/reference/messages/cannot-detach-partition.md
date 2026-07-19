---
message: "cannot detach partition \"%s\""
slug: cannot-detach-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_inherits.c:591"
reproduced: false
---

# `cannot detach partition "%s"`

## What it means

An `ALTER TABLE ... DETACH PARTITION` could not detach the named partition because of a dependency or state that blocks the operation — for example a foreign key that references the partition through the parent. The placeholder is the partition name.

## When it happens

It occurs when detaching a partition that other objects still depend on in a way the detach cannot resolve, or that is not in a detachable state.

## How to fix

Resolve the blocking dependency first — drop or adjust the referencing constraint — then detach. Review the message detail to see which dependency prevents the detach.

## Example

*Illustrative* — a blocked partition detach.

```text
ERROR:  cannot detach partition "p1"
```

## Related

- [cannot complete detaching partition](./cannot-complete-detaching-partition.md)
- [cannot detach partitions concurrently when a default partition exists](./cannot-detach-partitions-concurrently-when-a-default-partition-exists.md)
