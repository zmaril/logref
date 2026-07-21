---
message: "could not open server file \"%s\": %m"
slug: could-not-open-server-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:442"
reproduced: true
---

# `could not open server file "%s": %m`

## What it means

A server-side large-object function tried to open a file on the server's filesystem and the operating system refused. The `%m` reason gives the cause. `lo_import` and `lo_export` read and write files as the server's user.

## When it happens

It happens during `lo_import`/`lo_export` (or `COPY` to a server file) when the named path is missing, unreadable, or unwritable for the server's operating-system user — not the client's user.

## How to fix

Use a path that exists and is accessible to the server's operating-system account, remembering these functions act on the server's filesystem, not the client's. For client-side files, use `psql`'s `\lo_import`/`\lo_export` instead. Note that server-side variants are restricted to superusers by default.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT lo_import('/nonexistent');
```

Produces:

```text
ERROR:  could not open server file "/nonexistent": No such file or directory
```

## Related

- [could not open stdout for appending](./could-not-open-stdout-for-appending.md)
- [could not read from COPY file](./could-not-read-from-copy-file.md)
