---
message: "%s: could not open service manager\n"
slug: could-not-open-service-manager
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1521"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1555"
reproduced: false
---

# `%s: could not open service manager
`

## What it means

On Windows, a tool could not open the Service Control Manager, so it cannot register, query, or control the PostgreSQL service.

## When it happens

It arises from `pg_ctl` service operations (`register`, `unregister`, `start`, `stop`) when the call to open the SCM fails — commonly insufficient privileges.

## Is this a problem?

Run the command from an elevated (administrator) context so it can open the Service Control Manager. Confirm the account has service-management rights, then retry.

## Example

*Illustrative* — a failed SCM open.

```text
pg_ctl: could not open service manager
```

## Related

- [could not get token information: error code %lu](./could-not-get-token-information-error-code-aa1a0a.md)
- [could not start server: %m](./could-not-start-server.md)
