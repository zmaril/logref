---
message: "authentication identifier set more than once"
slug: authentication-identifier-set-more-than-once
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/libpq/auth.c:350"
reproduced: false
---

# `authentication identifier set more than once`

## What it means

During connection authentication the backend tried to record the authenticated identity twice. The identity is meant to be set exactly once per connection, so a second attempt is a programming-level violation in the auth path.

## When it happens

It is an internal guard in the authentication machinery. It can appear if an authentication method or an extension hook sets the identifier after it was already established.

## How to fix

This is not a client-fixable condition. If it appears, suspect a custom authentication provider or an extension that manipulates the auth identity, capture the `pg_hba.conf` method in use, and report it with the server version and any auth-related extensions loaded.

## Example

*Illustrative* — the guard during authentication.

```text
FATAL:  authentication identifier set more than once
```

## Related

- [background process terminated unexpectedly](./background-process-terminated-unexpectedly.md)
- [backend is incorrectly linked to frontend functions](./backend-is-incorrectly-linked-to-frontend-functions.md)
