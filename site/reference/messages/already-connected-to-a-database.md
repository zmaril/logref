---
message: "already connected to a database"
slug: already-connected-to-a-database
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:118"
reproduced: false
---

# `already connected to a database`

## What it means

A client tool tried to open a database connection while it already had one, which its workflow does not allow.

## When it happens

It is raised as fatal by tools whose logic expects to establish a single connection, when a second connect is attempted without closing the first.

## How to fix

This usually reflects a scripting or tool-usage mistake rather than a server problem. Ensure the tool connects once; if you are driving it programmatically, close or reuse the existing connection instead of opening another.

## Example

*Illustrative* — a second connect attempt in a single-connection tool.

```text
FATAL:  already connected to a database
```

## Related

- [all non-template0 databases must allow connections](./all-non-template0-databases-must-allow-connections-i-e-their-pg-database.md)
- [archive format is not supported; please use psql](./archive-format-is-not-supported-please-use-psql.md)
