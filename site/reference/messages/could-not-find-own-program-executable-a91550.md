---
message: "%s: could not find own program executable"
slug: could-not-find-own-program-executable-a91550
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:380"
reproduced: false
---

# `%s: could not find own program executable`

## What it means

`pg_upgrade` could not determine the path to its own executable. The leading `%s` names the program. It needs this to find the companion binaries it runs, and the lookup failed.

## When it happens

It happens at `pg_upgrade` startup when the program cannot resolve its own binary path, usually from an unusual invocation or a broken `PATH`/argv[0].

## How to fix

Invoke `pg_upgrade` with a normal path so it can find itself — run it from its installed location or via a `PATH` that includes it. Avoid launching it through wrappers that blank out argv[0].

## Example

*Illustrative* — pg_upgrade unable to locate its own binary.

```text
pg_upgrade: fatal: could not find own program executable
```

## Related

- [could not find own program executable](./could-not-find-own-program-executable-599b73.md)
- [could not connect to source postmaster started with the command](./could-not-connect-to-source-postmaster-started-with-the-command.md)
