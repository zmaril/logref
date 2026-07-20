---
message: "could not allocate SIDs: error code %lu"
slug: could-not-allocate-sids-error-code-ca3e4e
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/restricted_token.c:74"
reproduced: false
---

# `could not allocate SIDs: error code %lu`

## What it means

On Windows, a Postgres tool could not allocate the security identifiers (SIDs) it needs to build a restricted access token. The Windows API returned the shown error code, and the operation cannot continue.

## When it happens

It happens on Windows when a tool drops privileges by creating a restricted token and the SID allocation step fails.

## How to fix

This is a Windows security-API failure. Check that the account has the rights to create restricted tokens, review the error code against Windows documentation, and ensure the host's security subsystem is healthy. Running in an unusual or locked-down security context is a common cause.

## Example

*Illustrative* — a SID allocation failure on Windows.

```text
error: could not allocate SIDs: error code 1450
```

## Related

- [could not add execute permission to file](./could-not-add-execute-permission-to-file.md)
- [could not allocate memory for shared memory name](./could-not-allocate-memory-for-shared-memory-name.md)
