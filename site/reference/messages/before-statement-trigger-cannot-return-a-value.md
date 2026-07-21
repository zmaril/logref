---
message: "BEFORE STATEMENT trigger cannot return a value"
slug: before-statement-trigger-cannot-return-a-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED
    code: "39P01"
call_sites:
  - "postgres/src/backend/commands/trigger.c:2472"
  - "postgres/src/backend/commands/trigger.c:2701"
  - "postgres/src/backend/commands/trigger.c:2973"
  - "postgres/src/backend/commands/trigger.c:3347"
reproduced: false
---

# `BEFORE STATEMENT trigger cannot return a value`

## What it means

A `BEFORE STATEMENT` trigger function returned a non-null value. Statement-level triggers do not process rows, so their return value is ignored and must be null; returning something else is a protocol violation.

## When it happens

A trigger declared `BEFORE ... FOR EACH STATEMENT` whose function has a `RETURN <row/value>` path instead of `RETURN NULL`.

## How to fix

Make the trigger function `RETURN NULL` on all paths. Row-level manipulation (returning `NEW`/`OLD`) only applies to `FOR EACH ROW` triggers; a statement-level trigger must not return a value.

## Example

*Illustrative* — a statement trigger returning a value.

```text
ERROR:  BEFORE STATEMENT trigger cannot return a value
```

## Related

- [record has no field](./record-has-no-field.md)
- [cannot retrieve a system column in this context](./cannot-retrieve-a-system-column-in-this-context.md)
