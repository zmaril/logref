---
message: "could not parse %s array"
slug: could-not-parse-array
passthrough: false
api: [pg_fatal, pg_log_warning]
level: [FATAL, WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:4938"
  - "postgres/src/bin/pg_dump/pg_dump.c:5554"
  - "postgres/src/bin/pg_dump/pg_dump.c:8106"
  - "postgres/src/bin/pg_dump/pg_dump.c:13614"
  - "postgres/src/bin/pg_dump/pg_dump.c:20080"
  - "postgres/src/bin/pg_dump/pg_dump.c:20082"
  - "postgres/src/bin/pg_dump/pg_dump.c:20723"
reproduced: false
---

# `could not parse %s array`

## What it means

A tool (notably `pg_dump`) failed to parse an array value it read from the server. The placeholder is the array's kind/context. `pg_dump` reads several catalog values as arrays; a value that does not parse as a valid array literal stops or warns the dump.

## When it happens

A catalog array value that is malformed or in an unexpected format — often a sign of catalog corruption, or a `pg_dump` version older than the server whose array format it does not understand. The `FATAL` form aborts the dump; `WARNING` continues with degraded output.

## How to fix

Use a `pg_dump` version at least as new as the server — mismatches are the common cause. If the tool matches the server, suspect catalog corruption: inspect the relevant catalog value, verify with `amcheck`/consistency checks, and restore from backup if the catalog is damaged. Report reproducible cases.

## Example

*Illustrative* — pg_dump reading a malformed catalog array.

```text
pg_dump: warning: could not parse ACL array
```

## Related

- [unrecognized table OID %u](./unrecognized-table-oid.md)
- [could not read from input file: %m](./could-not-read-from-input-file-c5612a.md)
