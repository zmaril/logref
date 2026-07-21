---
message: "could not translate name"
slug: could-not-translate-name
passthrough: false
api: [ereport]
level: [LOG]
sqlstate:
  - symbol: ERRCODE_INVALID_ROLE_SPECIFICATION
    code: "0P000"
call_sites:
  - "postgres/src/backend/libpq/auth.c:1552"
  - "postgres/src/backend/libpq/auth.c:1571"
reproduced: false
---

# `could not translate name`

## What it means

A log message that a name-translation step could not resolve a name — in the role context, that a supplied name did not map to a valid role specification.

## When it happens

It arises where a name must be translated to an internal identity (for example during authentication or role mapping) and the mapping fails.

## Is this a problem?

Check the name and any mapping configuration (for example `pg_ident.conf` entries) involved. Confirm the target role exists and the mapping rule produces a valid role name.

## Example

*Illustrative* — a name that could not be translated.

```text
LOG:  could not translate name
```

## Related

- [missing entry at end of line](./missing-entry-at-end-of-line.md)
- [failed_for_address (getaddrinfo/getnameinfo)](./failed-for-address.md)
