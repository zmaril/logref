---
message: "program \"%s\" is needed by %s but was not found in the same directory as \"%s\""
slug: program-is-needed-by-but-was-not-found-in-the-same-directory-as-ab26d1
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2690"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:431"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:239"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1091"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1159"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:282"
reproduced: false
---

# `program "%s" is needed by %s but was not found in the same directory as "%s"`

## What it means

A Postgres binary looked for a helper program it depends on in the same directory as itself and did not find it. The placeholders are the missing program, the program that needs it, and the directory searched. `initdb`, for instance, needs the `postgres` executable beside it.

## When it happens

Running a tool such as `initdb`, `pg_ctl`, or `pg_upgrade` from an installation whose companion binaries are missing, or from a partially copied or broken install where only some executables were placed together.

## How to fix

Make sure the full matching set of Postgres binaries is installed together in one `bin` directory. Do not copy a single executable out on its own — the tools resolve their helpers relative to their own path. Reinstall or fix the packaging so the named program sits beside its caller.

## Example

*Illustrative* — initdb unable to find the server binary.

```text
FATAL:  program "postgres" is needed by initdb but was not found in the same directory as "/usr/local/pgsql/bin/initdb"
```

## Related

- [program was found by but was not the same version as](./program-was-found-by-but-was-not-the-same-version-as-ca5bfd.md)
- [could not change permissions of](./could-not-change-permissions-of.md)
