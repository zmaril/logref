---
message: "could not get home directory for user ID %ld: %s"
slug: could-not-get-home-directory-for-user-id
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:719"
reproduced: false
---

# `could not get home directory for user ID %ld: %s`

## What it means

`psql` tried to look up the current user's home directory and the system call failed. The `%s` value gives the reason. `psql` resolves the home directory to find files like `.psqlrc` and to expand a leading `~` in paths.

## When it happens

It happens in `psql` when the account running it has no home directory in the password database, or the lookup fails — common in minimal container images or when running under a synthetic user ID.

## How to fix

Run `psql` as a user that has a valid home directory, or set the `HOME` environment variable to a readable directory. In containers, adding a passwd entry for the runtime user, or exporting `HOME`, resolves it.

## Example

*Illustrative* — no home directory for the current user.

```text
psql: error: could not get home directory for user ID 1000: no such user
```

## Related

- [could not get current working directory](./could-not-get-current-working-directory.md)
- [could not get junction for](./could-not-get-junction-for.md)
