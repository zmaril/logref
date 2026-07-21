---
message: "could not open process token: error code %lu"
slug: could-not-open-process-token-error-code-87d277
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/restricted_token.c:60"
reproduced: false
---

# `could not open process token: error code %lu`

## What it means

On Windows, a Postgres program tried to open its own process access token and the operating-system call failed. The `%lu` value is the Windows error code. The token is opened to drop privileges by re-launching under a restricted token.

## When it happens

It happens on Windows when a program that lowers its own privileges cannot open the process token — an unusual operating-system-level failure, sometimes tied to a restricted or unusual account.

## How to fix

This is a low-level Windows failure. Confirm the account has the rights to open its own token and that the host is healthy, then rerun. Look up the reported error code for the precise cause.

## Example

*Illustrative* — the process token could not be opened.

```text
pg_ctl: error: could not open process token: error code 5
```

## Related

- [could not re-execute with restricted token: error code](./could-not-re-execute-with-restricted-token-error-code.md)
- [could not look up account SID: error code](./could-not-look-up-account-sid-error-code.md)
