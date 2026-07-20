---
message: "could not parse connection string: %s"
slug: could-not-parse-connection-string
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:364"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:354"
reproduced: false
---

# `could not parse connection string: %s`

## What it means

A connection string could not be parsed while starting a replication or subscriber connection. The `%s` is libpq's parse error. The connection cannot be attempted with an unparseable string.

## When it happens

A malformed `conninfo` or connection URI was supplied — a bad keyword, an unbalanced quote, or a stray character — to a subscription, `pg_createsubscriber`, or a walreceiver.

## How to fix

Fix the connection string to valid libpq syntax (either `key=value` pairs or a `postgresql://` URI). The trailing error names the problem token.

## Example

*Illustrative* — a malformed conninfo string.

```text
ERROR:  could not parse connection string: missing "=" after "hostlocalhost" in connection info string
```

## Related

- [could not identify system](./could-not-identify-system-got-rows-and-fields-expected-rows-and-or-more-fields.md)
- [could not parse end position](./could-not-parse-end-position.md)
