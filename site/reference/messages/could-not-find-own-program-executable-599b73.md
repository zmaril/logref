---
message: "could not find own program executable"
slug: could-not-find-own-program-executable-599b73
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/psql/startup.c:792"
reproduced: false
---

# `could not find own program executable`

## What it means

`psql` could not determine the path to its own executable. It needs this to locate companion files relative to itself, and the lookup failed.

## When it happens

It happens at `psql` startup when the program cannot resolve its own binary path, usually because of an unusual invocation or a broken `PATH`/argv[0].

## How to fix

Invoke `psql` with a normal path so it can find itself — run it from its installed location or via a `PATH` that includes it. Avoid launching it through wrappers that blank out argv[0].

## Example

*Illustrative* — psql unable to locate its own binary.

```text
psql: fatal: could not find own program executable
```

## Related

- [could not find own program executable](./could-not-find-own-program-executable-a91550.md)
- [could not find file](./could-not-find-file.md)
