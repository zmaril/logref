---
message: "could not parse reloptions array"
slug: could-not-parse-reloptions-array
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:6357"
reproduced: false
---

# `could not parse reloptions array`

## What it means

`psql` read a relation's storage-options array (`reloptions`) while building meta-command output and could not parse it. The array holds per-object settings such as `fillfactor` and autovacuum overrides.

## When it happens

It happens in `psql` (for example during `\d+`) when the `reloptions` value it read is not in the array form it expects — usually a version mismatch between `psql` and the server.

## How to fix

Use a `psql` whose version matches (or is newer than) the server, since newer option formats can confuse an older client. If the versions already match, capture the object definition and report a reproducible case.

## Example

*Illustrative* — an unparsable reloptions array.

```text
psql: error: could not parse reloptions array
```

## Related

- [could not parse contents of file](./could-not-parse-contents-of-file.md)
- [could not make operator class be default for type](./could-not-make-operator-class-be-default-for-type.md)
