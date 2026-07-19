---
message: "%s(%s) failed for %s address \"%s\": %m"
slug: failed-for-address
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:573"
  - "postgres/src/backend/libpq/pqcomm.c:591"
reproduced: false
---

# `%s(%s) failed for %s address "%s": %m`

## What it means

A log message that a name-resolution call (such as `getaddrinfo`/`getnameinfo`) failed for a given address; the parenthesized function and the errno string give the detail.

## When it happens

It arises when the server resolves host names or addresses (for connection logging, `pg_hba.conf` host matching, or listen setup) and the operating-system resolver call fails.

## Is this a problem?

Check the reported function and errno. Verify DNS/resolver configuration and that the address or host name is valid; a transient resolver failure may clear on its own, while a persistent one points to a name-service problem.

## Example

*Illustrative* — a failed address resolution.

```text
LOG:  getaddrinfo(example) failed for host address "example": Name or service not known
```

## Related

- [pg_getnameinfo_all() failed: %s](./pg-getnameinfo-all-failed.md)
- [could not translate name](./could-not-translate-name.md)
