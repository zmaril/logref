---
message: "could not apply concurrent %s on relation \"%s\""
slug: could-not-apply-concurrent-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/commands/repack.c:2705"
  - "postgres/src/backend/commands/repack.c:2743"
reproduced: false
---

# `could not apply concurrent %s on relation "%s"`

## What it means

A concurrent maintenance operation (such as `REPACK`) could not apply changes made by other transactions to the relation while it was rebuilding. The placeholders are the operation and the relation. Serialization with concurrent writes failed, so the operation gave up rather than lose changes.

## When it happens

Running a concurrent `REPACK` (or similar) on a heavily written table where the volume or timing of concurrent modifications prevents the operation from catching up and applying them.

## How to fix

Retry the operation, ideally during a quieter period with less concurrent write activity on the table. The error is a serialization-style failure and is safe to re-run. Reducing concurrent load or scheduling maintenance in a low-traffic window improves the chance of success.

## Example

*Illustrative* — a concurrent repack failing to catch up.

```text
ERROR:  could not apply concurrent REPACK on relation "orders"
```

## Related

- [could not find target tuple](./could-not-find-target-tuple.md)
- [could not change access method dependency for relation](./could-not-change-access-method-dependency-for-relation.md)
