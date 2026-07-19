---
message: "directory \"%s\" does not exist"
slug: directory-does-not-exist-40b4bd
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FILE
    code: "58P01"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:617"
reproduced: false
---

# `directory "%s" does not exist`

## What it means

`CREATE TABLESPACE` named a location directory that does not exist on the server's filesystem. The placeholder is the path.

## When it happens

It fires from `CREATE TABLESPACE` when the `LOCATION` path is not present, or is not visible to the server process.

## How to fix

Create the directory on the database server host before running `CREATE TABLESPACE`, make it owned by the OS user the server runs as, and give the path an absolute value. The path is interpreted on the server, not the client.

## Example

*Illustrative* — a missing tablespace directory.

```sql
CREATE TABLESPACE ts LOCATION '/data/missing';
-- directory "/data/missing" does not exist
```

## Related

- [directory already in use as a tablespace](./directory-already-in-use-as-a-tablespace.md)
- [directory is not empty](./directory-is-not-empty.md)
