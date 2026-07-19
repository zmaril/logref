---
message: "invalid connection limit: %d"
slug: invalid-connection-limit
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/user.c:304"
  - "postgres/src/backend/commands/user.c:744"
reproduced: false
---

# `invalid connection limit: %d`

## What it means

A connection-limit value given for a role or database is not acceptable. Valid limits are `-1` (unlimited) or a non-negative integer; the placeholder shows the rejected value.

## When it happens

It arises from `CREATE ROLE`/`ALTER ROLE ... CONNECTION LIMIT n` or `CREATE DATABASE`/`ALTER DATABASE ... CONNECTION LIMIT n` when `n` is below `-1`.

## How to fix

Pass `-1` for no limit or a value of `0` or greater to cap concurrent connections. Do not pass values below `-1`.

## Example

*Illustrative* — a limit below the allowed floor.

```sql
ALTER ROLE app CONNECTION LIMIT -5;  -- use -1 or >= 0
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [maximum number of prepared transactions reached](./maximum-number-of-prepared-transactions-reached.md)
