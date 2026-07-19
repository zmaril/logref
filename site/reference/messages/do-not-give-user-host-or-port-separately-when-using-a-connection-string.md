---
message: "Do not give user, host, or port separately when using a connection string"
slug: do-not-give-user-host-or-port-separately-when-using-a-connection-string
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:3938"
reproduced: false
---

# `Do not give user, host, or port separately when using a connection string`

## What it means

A psql `\connect` command supplied a connection string (a `postgresql://` URI or a `key=value` string) together with separate user, host, or port arguments. The two forms cannot be mixed.

## When it happens

It fires from psql's `\c`/`\connect` when the first argument is a full connection string and additional positional arguments were also given.

## How to fix

Put everything in the connection string, or use only separate positional arguments — not both. For example use `\c "host=db port=5433 user=app dbname=mydb"` alone, or `\c mydb app db 5433` with plain arguments.

## Example

*Illustrative* — mixing a URI with positional arguments.

```text
\c postgresql://db/mydb app
-- Do not give user, host, or port separately when using a connection string
```

## Related

- [environment variable name must not contain "="](./environment-variable-name-must-not-contain.md)
- [\df only takes [...] as options](./df-only-takes-as-options.md)
