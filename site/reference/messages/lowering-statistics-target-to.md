---
message: "lowering statistics target to %d"
slug: lowering-statistics-target-to
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:704"
  - "postgres/src/backend/commands/tablecmds.c:9090"
reproduced: false
---

# `lowering statistics target to %d`

## What it means

A warning that a requested statistics target was reduced to a lower value that the operation could support.

## When it happens

It arises when a statistics target (for example for `ANALYZE` or a column's `SET STATISTICS`) exceeds what a context allows, so it is clamped and the adjusted value is reported.

## Is this a problem?

Usually no action is needed — the reduced target still produces statistics. If you need a higher target, address the underlying limit named in the surrounding log, then set the target within the supported range.

## Example

*Illustrative* — clamping a statistics target.

```text
WARNING:  lowering statistics target to 10000
```

## Related

- [invalid stats kind %u for entry of type %c](./invalid-stats-kind-for-entry-of-type.md)
- [could not find extended statistics object "%s.%s"](./could-not-find-extended-statistics-object.md)
