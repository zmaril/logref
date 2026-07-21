---
message: "invalid value for boolean option \"%s\": %s"
slug: invalid-value-for-boolean-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/common/reloptions.c:1713"
  - "postgres/src/backend/access/common/reloptions.c:1727"
reproduced: true
---

# `invalid value for boolean option "%s": %s`

## What it means

An option that expects a boolean was given a value that does not read as true or false. The placeholders name the option and the rejected value.

## When it happens

It arises in `OPTIONS (...)` lists and similar settings — foreign-data-wrapper options, extension options, some tool arguments — when a boolean option receives something other than a recognized truth value.

## How to fix

Use a recognized boolean literal: `true`/`false`, `on`/`off`, `yes`/`no`, or `1`/`0`. Quote it as the option syntax requires. Check for a stray value or a typo in the option list.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at SET (autovacuum_enabled = maybe);
```

Produces:

```text
ERROR:  invalid value for boolean option "autovacuum_enabled": maybe
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [invalid value for floating point option](./invalid-value-for-floating-point-option.md)
