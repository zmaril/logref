---
message: "program \"%s\" was found by \"%s\" but was not the same version as %s"
slug: program-was-found-by-but-was-not-the-same-version-as-ca5bfd
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2693"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:434"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:242"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1094"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1162"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:285"
reproduced: false
---

# `program "%s" was found by "%s" but was not the same version as %s`

## What it means

A Postgres binary found its required helper program beside it, but that helper reports a different version than the caller. The placeholders are the helper program, the caller, and the caller's version. The tools refuse to run a mismatched pair because behavior can differ across versions.

## When it happens

Running a tool like `initdb` or `pg_ctl` from an installation where the companion binaries in the same directory come from a different Postgres release — usually a botched upgrade or two versions installed over each other.

## How to fix

Install a consistent set of binaries: the caller and its helpers must all be the same Postgres version. Clean up the mixed installation so the directory holds exactly one version, then re-run the tool.

## Example

*Illustrative* — a version-mismatched binary pair.

```text
FATAL:  program "postgres" was found by "initdb" but was not the same version as initdb
```

## Related

- [program is needed by but was not found in the same directory as](./program-is-needed-by-but-was-not-found-in-the-same-directory-as-ab26d1.md)
- [connection failure](./connection-failure.md)
