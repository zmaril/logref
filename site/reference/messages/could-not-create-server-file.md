---
message: "could not create server file \"%s\": %m"
slug: could-not-create-server-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:524"
reproduced: false
---

# `could not create server file "%s": %m`

## What it means

A server-side large-object export (`lo_export`) could not create the destination file on the server's filesystem. The `%m` reason gives the OS error.

## When it happens

It happens during `lo_export` when the server process cannot create the target path — a missing directory, wrong permissions for the server user, or a full filesystem.

## How to fix

Choose a path the server's operating-system user can write to, and confirm the directory exists with room to spare. Note that `lo_export` writes on the server host, not the client.

## Example

*Illustrative* — a server-side export path that cannot be created.

```sql
SELECT lo_export(16400, '/root/out.dat');
-- ERROR:  could not create server file "/root/out.dat": Permission denied
```

## Related

- [could not create large object](./could-not-create-large-object.md)
- [could not create lock file](./could-not-create-lock-file.md)
