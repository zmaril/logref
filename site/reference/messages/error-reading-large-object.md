---
message: "error reading large object %u: %s"
slug: error-reading-large-object
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:4168"
reproduced: false
---

# `error reading large object %u: %s`

## What it means

`pg_dump` failed to read the contents of a large object from the server. The placeholders are the large object's OID and the error. The large-object data could not be retrieved.

## When it happens

It fires in `pg_dump` while dumping large objects, when reading one fails — a connection break, a server error, or a permissions problem on the large object.

## How to fix

Check the server log for the underlying cause. Confirm the dumping role can read the large objects and the connection stayed up, then rerun. A `statement_timeout` on the role can also interrupt a long large-object read.

## Example

*Illustrative* — a large-object read failure.

```text
pg_dump: error: error reading large object 16452: ...
```

## Related

- [error reading large object TOC file](./error-reading-large-object-toc-file.md)
- [error during writing](./error-during-writing-929603.md)
