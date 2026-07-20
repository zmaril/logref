---
message: "failed to fetch tuple1 for AFTER trigger"
slug: failed-to-fetch-tuple1-for-after-trigger
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:4435"
  - "postgres/src/backend/commands/trigger.c:4482"
reproduced: false
---

# `failed to fetch tuple1 for AFTER trigger`

## What it means

Internal error while firing an AFTER trigger. The executor could not fetch the first row (the OLD image, or the row for a per-row trigger) that the trigger needs. It is a consistency guard in the trigger machinery.

## When it happens

It fires at AFTER-trigger execution time when the stored row reference could not be re-fetched. Ordinary triggers fire normally; this signals an unexpected state, sometimes tied to corruption.

## How to fix

This is a can't-happen guard. If it recurs, check the table and indexes for corruption and storage health, and report a reproducible case with the trigger and statement.

## Example

*Illustrative* — an AFTER trigger could not fetch its row.

```text
ERROR:  failed to fetch tuple1 for AFTER trigger
```

## Related

- [failed to fetch tuple2 for AFTER trigger](./failed-to-fetch-tuple2-for-after-trigger.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
