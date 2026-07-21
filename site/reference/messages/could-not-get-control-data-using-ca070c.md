---
message: "could not get control data using %s: %m"
slug: could-not-get-control-data-using-ca070c
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:127"
  - "postgres/src/bin/pg_upgrade/controldata.c:192"
reproduced: false
---

# `could not get control data using %s: %m`

## What it means

`pg_upgrade` could not run `pg_controldata` to read a cluster's control file. The `%s` is the command and the `%m` is the operating-system error from launching or reading it. Without control data the upgrade stops.

## When it happens

The `pg_controldata` executable could not be launched — a wrong `bindir`, a missing or non-executable binary, or a permission problem on the path.

## How to fix

Confirm the binary named in the message exists and is executable, and that `--old-bindir`/`--new-bindir` are correct for each cluster version. Re-run once the path resolves.

## Example

*Illustrative* — the control-data binary could not be executed.

```text
could not get control data using /new/bin/pg_controldata: Permission denied
```

## Related

- [could not get control data using](./could-not-get-control-data-using-05ca73.md)
- [could not locate my own executable path](./could-not-locate-my-own-executable-path.md)
