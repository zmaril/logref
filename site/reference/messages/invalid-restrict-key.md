---
message: "invalid restrict key"
slug: invalid-restrict-key
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:905"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:510"
  - "postgres/src/bin/pg_dump/pg_restore.c:377"
reproduced: false
---

# `invalid restrict key`

## What it means

Internal error in pg_dump. While building the ordered set of objects to dump, the tool encountered a restrict key it could not resolve. It is a consistency check inside the dump program's dependency handling.

## When it happens

It should not occur during a normal dump. Reaching it points to an internal inconsistency in pg_dump's object bookkeeping rather than to a problem with your database contents.

## How to fix

Treat it as a client-tool bug. Confirm the pg_dump version matches or exceeds the server version, retry with a matching build, and if it persists, capture the exact command and report it. There is no server-side change expected to trigger or avoid it.

## Example

*Illustrative* — raised internally by pg_dump.

```text
pg_dump: error: invalid restrict key
```

## Related

- [option requires option](./option-requires-option.md)
- [aborting because of server version mismatch](./aborting-because-of-server-version-mismatch.md)
