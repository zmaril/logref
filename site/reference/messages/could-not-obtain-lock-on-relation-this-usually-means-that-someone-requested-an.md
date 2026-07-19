---
message: "could not obtain lock on relation \"%s\"\nThis usually means that someone requested an ACCESS EXCLUSIVE lock on the table after the pg_dump parent process had gotten the initial ACCESS SHARE lock on the table."
slug: could-not-obtain-lock-on-relation-this-usually-means-that-someone-requested-an
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:1321"
reproduced: false
---

# `could not obtain lock on relation "%s"
This usually means that someone requested an ACCESS EXCLUSIVE lock on the table after the pg_dump parent process had gotten the initial ACCESS SHARE lock on the table.`

## What it means

A parallel `pg_dump` worker tried to take a share lock on a table and could not because a stronger lock request is queued ahead of it. The message explains that something asked for an `ACCESS EXCLUSIVE` lock after the parent had taken its initial share lock.

## When it happens

It happens during a parallel dump when a worker connects to lock a table and a conflicting `ACCESS EXCLUSIVE` request (for example a `DROP`, `ALTER`, `VACUUM FULL`, or `TRUNCATE`) is already waiting — the worker cannot get its share lock without blocking behind that request.

## How to fix

Avoid running DDL or other strong-lock operations against the tables you are dumping while a parallel dump is in progress. Rerun the dump when no conflicting lock is queued, or use a non-parallel dump, which holds all its locks in the parent from the start.

## Example

*Illustrative* — a parallel worker blocked behind a stronger lock.

```text
pg_dump: fatal: could not obtain lock on relation "public.orders"
```

## Related

- [could not open TOC file](./could-not-open-toc-file.md)
- [could not re-open the output file](./could-not-re-open-the-output-file.md)
