---
message: "pg_getnameinfo_all() failed: %s"
slug: pg-getnameinfo-all-failed
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/libpq/auth.c:2141"
  - "postgres/src/backend/tcop/backend_startup.c:210"
reproduced: false
---

# `pg_getnameinfo_all() failed: %s`

## What it means

A warning that the server's address-formatting helper (`pg_getnameinfo_all`) could not render a network address into text; the detail gives the reason.

## When it happens

It arises when formatting a client or peer address for logging or matching and the underlying name-info call fails, so the address cannot be shown normally.

## Is this a problem?

Usually harmless — the server substitutes a placeholder and continues. If it recurs, check the host's name-resolution configuration; the detail names the failure.

## Example

*Illustrative* — a failed address format.

```text
WARNING:  pg_getnameinfo_all() failed: ai_family not supported
```

## Related

- [failed_for_address (getaddrinfo/getnameinfo)](./failed-for-address.md)
- [could not get result of cancel request: %s](./could-not-get-result-of-cancel-request.md)
