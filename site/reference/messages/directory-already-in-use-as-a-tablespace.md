---
message: "directory \"%s\" already in use as a tablespace"
slug: directory-already-in-use-as-a-tablespace
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:655"
reproduced: false
---

# `directory "%s" already in use as a tablespace`

## What it means

`CREATE TABLESPACE` pointed at a directory that already holds a tablespace. The placeholder is the directory path. A directory can back only one tablespace.

## When it happens

It fires from `CREATE TABLESPACE` when the target `LOCATION` already contains the marker file of another tablespace.

## How to fix

Point the new tablespace at an empty directory that no other tablespace uses. If the directory is left over from a dropped tablespace, verify it is truly unused and clear it, or choose a fresh path.

## Example

*Illustrative* — reusing a tablespace directory.

```sql
CREATE TABLESPACE ts LOCATION '/data/ts1';
-- directory "/data/ts1" already in use as a tablespace
```

## Related

- [directory does not exist](./directory-does-not-exist-40b4bd.md)
- [directory is not empty](./directory-is-not-empty.md)
