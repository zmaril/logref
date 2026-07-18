---
message: "setting an MD5-encrypted password"
slug: setting-an-md5-encrypted-password
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_WARNING_DEPRECATED_FEATURE
    code: "01P01"
call_sites:
  - "postgres/src/backend/libpq/crypt.c:244"
reproduced: false
---

# `setting an MD5-encrypted password`

## What it means

A password was stored using the legacy MD5 hashing scheme. Postgres warns because MD5 password authentication is deprecated in favor of `scram-sha-256`, which is stronger. The password was set — this is a heads-up, not a failure.

## When it happens

`ALTER ROLE r PASSWORD` (or `CREATE ROLE`) while `password_encryption` is set to `md5`, or loading a role whose password is a pre-hashed MD5 string. Older clients and configs still default to MD5.

## Is this a problem?

Move to SCRAM: set `password_encryption = scram-sha-256` in `postgresql.conf` (reload), then have each role set a new password so it is re-hashed under SCRAM. Update `pg_hba.conf` methods from `md5` to `scram-sha-256` once clients support it (libpq since PostgreSQL 10). Until then the MD5 password keeps working; the warning simply flags the weaker scheme.

## Example

*Illustrative* — setting a password under the legacy scheme.

```sql
SET password_encryption = 'md5';
CREATE ROLE app LOGIN PASSWORD 'secret';
```

Produces:

```text
WARNING:  setting an MD5-encrypted password
```

## Related

- [empty string is not a valid password, clearing password](./empty-string-is-not-a-valid-password-clearing-password.md)
