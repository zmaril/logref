---
message: "%s: could not start server: %m\n"
slug: could-not-start-server
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:459"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:501"
reproduced: false
---

# `%s: could not start server: %m
`

## What it means

A control tool could not start the server process; the errno string gives the operating-system reason.

## When it happens

It arises from `pg_ctl start` (and similar) when launching the postmaster fails — a bad executable path, missing permissions, or an environment problem.

## Is this a problem?

Check the errno and the server log. Confirm the data directory and executable are correct and accessible, that the port is free, and that the server's user has the needed permissions, then retry.

## Example

*Illustrative* — a server that would not start.

```text
pg_ctl: could not start server: No such file or directory
```

## Related

- [could not access directory "%s": %m](./could-not-access-directory-c42d05.md)
- [could not open service manager](./could-not-open-service-manager.md)
