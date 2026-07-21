---
message: "%s: could not get token information: error code %lu\n"
slug: could-not-get-token-information-error-code-aa1a0a
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1928"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1943"
reproduced: false
---

# `%s: could not get token information: error code %lu
`

## What it means

On Windows, a tool could not read the access-token information for the current process; the reported error code is the operating-system reason.

## When it happens

It arises in Windows-specific startup or privilege checks (for example in `pg_ctl` or the postmaster) when querying the process token fails.

## Is this a problem?

Check the Windows error code. Ensure the account running the tool has the rights to query its own token, and that no security policy or wrapper is blocking the call; retry under a suitable account.

## Example

*Illustrative* — a failed Windows token query.

```text
pg_ctl: could not get token information: error code 5
```

## Related

- [could not open service manager](./could-not-open-service-manager.md)
- [could not start server: %m](./could-not-start-server.md)
