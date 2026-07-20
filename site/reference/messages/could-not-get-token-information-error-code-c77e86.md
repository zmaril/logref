---
message: "could not get token information: error code %lu"
slug: could-not-get-token-information-error-code-c77e86
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth.c:1438"
reproduced: false
---

# `could not get token information: error code %lu`

## What it means

On Windows, the server tried to read the contents of a security token and the operating-system call failed. The `%lu` value is the Windows error code. The token identifies the connecting user during authentication.

## When it happens

It fires during Windows authentication (for example SSPI), when `GetTokenInformation` fails while reading the token after its size was determined — an unusual operating-system-level failure.

## How to fix

This is a low-level Windows failure during authentication. Confirm the service account can inspect access tokens and that the host is stable. Look up the reported error code for the precise cause and retry once the environment is healthy.

## Example

*Illustrative* — the token information could not be read.

```text
ERROR:  could not get token information: error code 1450
```

## Related

- [could not get token information buffer size error code](./could-not-get-token-information-buffer-size-error-code.md)
- [could not get exit code from subprocess error code](./could-not-get-exit-code-from-subprocess-error-code.md)
