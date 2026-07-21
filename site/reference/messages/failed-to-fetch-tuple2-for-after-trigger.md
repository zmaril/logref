---
message: "failed to fetch tuple2 for AFTER trigger"
slug: failed-to-fetch-tuple2-for-after-trigger
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:4441"
  - "postgres/src/backend/commands/trigger.c:4524"
reproduced: false
---

# `failed to fetch tuple2 for AFTER trigger`

## What it means

Internal error while firing an AFTER trigger. The executor could not fetch the second row (the NEW image) that an update trigger needs. It is a consistency guard in the trigger machinery.

## When it happens

It fires at AFTER-trigger time for an update when the new-row reference could not be re-fetched. Ordinary triggers fire normally; this signals an unexpected state.

## How to fix

This is a can't-happen guard. If it recurs, check the table and indexes for corruption and report a reproducible case with the trigger and statement.

## Example

*Illustrative* — an AFTER trigger could not fetch its new row.

```text
ERROR:  failed to fetch tuple2 for AFTER trigger
```

## Related

- [failed to fetch tuple1 for AFTER trigger](./failed-to-fetch-tuple1-for-after-trigger.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
