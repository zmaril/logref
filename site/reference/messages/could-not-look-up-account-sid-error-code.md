---
message: "could not look up account SID: error code %lu"
slug: could-not-look-up-account-sid-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth.c:1446"
reproduced: false
---

# `could not look up account SID: error code %lu`

## What it means

On Windows, the server tried to resolve the connecting account's security identifier (SID) during authentication and the call failed. The `%lu` value is the Windows error code. The SID identifies the account for access checks.

## When it happens

It fires during Windows authentication (for example SSPI), when looking up the account SID fails — usually a domain or directory problem, or a token the server cannot resolve.

## How to fix

This is a Windows authentication failure. Confirm the account and domain are reachable and that the service account can look up account information. Look up the reported error code for the precise cause, then retry once the directory is reachable.

## Example

*Illustrative* — the account SID could not be resolved.

```text
ERROR:  could not look up account SID: error code 1332
```

## Related

- [could not open process token: error code](./could-not-open-process-token-error-code-87d277.md)
- [could not re-execute with restricted token: error code](./could-not-re-execute-with-restricted-token-error-code.md)
