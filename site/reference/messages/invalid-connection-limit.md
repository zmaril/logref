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
reproduced: true
---

# `invalid connection limit: %d`

## What it means

A connection-limit value given for a role or database is not acceptable. Valid limits are `-1` (unlimited) or a non-negative integer; the placeholder shows the rejected value.

## When it happens

It arises from `CREATE ROLE`/`ALTER ROLE ... CONNECTION LIMIT n` or `CREATE DATABASE`/`ALTER DATABASE ... CONNECTION LIMIT n` when `n` is below `-1`.

## How to fix

Pass `-1` for no limit or a value of `0` or greater to cap concurrent connections. Do not pass values below `-1`.

## Example

*Reproduced* — captured from `reproducers/scenarios/33_grant_roles_coerce_dml.sql`.

```sql
CREATE ROLE r_conn CONNECTION LIMIT -5 LOGIN;
```

Produces:

```text
ERROR:  invalid connection limit: -5
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [maximum number of prepared transactions reached](./maximum-number-of-prepared-transactions-reached.md)
