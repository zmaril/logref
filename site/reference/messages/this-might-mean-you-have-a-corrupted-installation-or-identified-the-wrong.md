---
message: "This might mean you have a corrupted installation or identified the wrong directory with the invocation option -L."
slug: this-might-mean-you-have-a-corrupted-installation-or-identified-the-wrong
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:1018"
  - "postgres/src/bin/initdb/initdb.c:1023"
  - "postgres/src/bin/initdb/initdb.c:1030"
reproduced: false
---

# `This might mean you have a corrupted installation or identified the wrong directory with the invocation option -L.`

## What it means

A hint from initdb, printed after it fails to find or validate the files it expects. It suggests two likely causes: a damaged installation, or the wrong installation directory passed with the `-L` option. It accompanies a preceding error that names what was missing.

## When it happens

Running initdb when it cannot locate its input files — a broken or incomplete installation, or an `-L` path that points somewhere other than the share directory holding initdb's templates.

## How to fix

Confirm the Postgres installation is complete and the share directory is intact, and check the `-L` option if you passed one so it names the correct directory. Reinstalling the server package restores missing template files. Read the error printed just before this hint; it names the specific file or directory that was missing.

## Example

*Illustrative* — the hint following an initdb failure.

```text
initdb: This might mean you have a corrupted installation or identified the wrong directory with the invocation option -L.
```

## Related

- [could not read from file](./could-not-read-from-file.md)
- [invalid value for option](./invalid-value-for-option.md)
