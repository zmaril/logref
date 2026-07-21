---
message: "could not set environment: %m"
slug: could-not-set-environment-260416
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/libpq/auth.c:980"
  - "postgres/src/backend/libpq/be-secure-gssapi.c:553"
reproduced: false
---

# `could not set environment: %m`

## What it means

A server process could not set an environment variable it needed, and treated the failure as out of memory. The `%m` is the operating-system error. It fires in authentication paths (for example GSSAPI/Kerberos setup).

## When it happens

A `setenv`/`putenv` failed while preparing the environment for an auth mechanism — typically under memory pressure or an unusual environment.

## How to fix

This usually reflects host memory or environment limits. Check available memory and any restrictions on the server process's environment. If it recurs on a healthy host, capture the auth method and report it.

## Example

*Illustrative* — setting an auth environment variable failed.

```text
FATAL:  could not set environment: Cannot allocate memory
```

## Related

- [could not load](./could-not-load-078321.md)
- [getrlimit failed](./getrlimit-failed.md)
