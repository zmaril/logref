---
message: "cannot process DELETE events"
slug: cannot-process-delete-events
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/spi/autoinc.c:55"
reproduced: false
---

# `cannot process DELETE events`

## What it means

The `autoinc` trigger from the spi contrib module was fired for a `DELETE`. The `autoinc` trigger maintains an auto-incrementing column on inserts and updates and has nothing to do on a delete, so it rejects that event.

## When it happens

It occurs when a trigger using the `autoinc()` function is defined to fire on `DELETE`. The function supports only `INSERT` and `UPDATE`.

## How to fix

Restrict the trigger to `BEFORE INSERT OR UPDATE`. Drop `DELETE` from the trigger's event list so `autoinc()` is never invoked for a delete.

## Example

*Illustrative* — autoinc fired on a delete.

```text
ERROR:  cannot process DELETE events
```

## Related

- [cannot perform DELETE RETURNING on relation](./cannot-perform-delete-returning-on-relation.md)
- [cannot rename trigger on table](./cannot-rename-trigger-on-table.md)
