---
message: "could not parse server version \"%s\""
slug: could-not-parse-server-version
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:205"
reproduced: false
---

# `could not parse server version "%s"`

## What it means

`pg_dump` read the connected server's version string and could not interpret it. The `%s` value gives the raw string. It parses the version to decide which features and catalog queries apply.

## When it happens

It happens right after connecting when the server's version string is not in a form the tool recognizes — usually a non-PostgreSQL endpoint, or a fork reporting an unexpected version string.

## How to fix

Confirm you are connecting to a genuine PostgreSQL server whose version `pg_dump` supports. If a fork or proxy reports a non-standard version string, connecting directly to a supported server resolves it.

## Example

*Illustrative* — an unparsable server version string.

```text
pg_dump: fatal: could not parse server version "MyForkDB 1.0"
```

## Related

- [could not parse version file](./could-not-parse-version-file.md)
- [could not parse result of current_schemas()](./could-not-parse-result-of-current-schemas.md)
