---
message: "could not get token information buffer size: error code %lu"
slug: could-not-get-token-information-buffer-size-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth.c:1428"
reproduced: false
---

# `could not get token information buffer size: error code %lu`

## What it means

On Windows, the server asked the operating system how large a buffer it needs to read a security token's information and the call failed. The `%lu` value is the Windows error code. It sizes the buffer before reading the token.

## When it happens

It fires during authentication on Windows (for example SSPI), when `GetTokenInformation` fails while probing the required buffer size — an unusual operating-system-level failure during the security handshake.

## How to fix

This is a low-level Windows failure during authentication. Confirm the service account has the rights to inspect access tokens and that the host is stable. Look up the reported error code for the cause; retry once the environment is healthy.

## Example

*Illustrative* — the token buffer size could not be read.

```text
ERROR:  could not get token information buffer size: error code 1450
```

## Related

- [could not get token information error code](./could-not-get-token-information-error-code-c77e86.md)
- [could not get exit code from subprocess error code](./could-not-get-exit-code-from-subprocess-error-code.md)
