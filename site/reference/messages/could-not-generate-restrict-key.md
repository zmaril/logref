---
message: "could not generate restrict key"
slug: could-not-generate-restrict-key
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:903"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:508"
  - "postgres/src/bin/pg_dump/pg_restore.c:375"
reproduced: false
---

# `could not generate restrict key`

## What it means

`pg_dump` could not generate a restrict key used to protect the dump's restore script against injection through object names. The placeholder-free message reflects a failure in producing the random key `pg_dump` embeds so that `psql` restores run safely. Without it the dump cannot proceed securely.

## When it happens

A failure in the random-number source `pg_dump` uses to create the key — for example an environment where the cryptographic RNG is unavailable or errored. It is not caused by the database contents.

## How to fix

Ensure the system's random-number source is available to the tool (a functioning `/dev/urandom` or the platform equivalent, and a correctly linked OpenSSL/crypto library), then re-run `pg_dump`. If it persists in a constrained environment, investigate why the RNG is failing. Report reproducible cases with the platform details.

## Example

*Illustrative* — a failed restrict-key generation in pg_dump.

```text
pg_dump: error: could not generate restrict key
```

## Related

- [could not initialize compression library](./could-not-initialize-compression-library-144690.md)
- [could not close TOC file](./could-not-close-toc-file.md)
