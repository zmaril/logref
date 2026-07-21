---
message: "could not re-execute with restricted token: error code %lu"
slug: could-not-re-execute-with-restricted-token-error-code
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/restricted_token.c:153"
reproduced: false
---

# `could not re-execute with restricted token: error code %lu`

## What it means

On Windows, a Postgres program tried to relaunch itself under a restricted access token to drop administrator privileges and the relaunch failed. The `%lu` value is the Windows error code. Server programs refuse to run with full administrator rights.

## When it happens

It happens on Windows when a program (for example `pg_ctl` or `initdb`) cannot re-execute itself under a lower-privilege token — usually a restricted environment, or missing rights to create the restricted process.

## How to fix

This is a Windows privilege-management failure. Confirm the account can create processes with a restricted token and that no policy blocks the relaunch. Look up the reported error code for the specific cause, then rerun in a normal environment.

## Example

*Illustrative* — the restricted-token relaunch failed.

```text
pg_ctl: error: could not re-execute with restricted token: error code 5
```

## Related

- [could not open process token: error code](./could-not-open-process-token-error-code-87d277.md)
- [could not look up account SID: error code](./could-not-look-up-account-sid-error-code.md)
