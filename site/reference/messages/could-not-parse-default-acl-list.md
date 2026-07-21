---
message: "could not parse default ACL list (%s)"
slug: could-not-parse-default-acl-list
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:16324"
reproduced: false
---

# `could not parse default ACL list (%s)`

## What it means

`pg_dump` read a stored default-privileges entry (from `ALTER DEFAULT PRIVILEGES`) and could not parse it. The `%s` value gives the raw text. It parses these entries to reproduce default privileges in the dump.

## When it happens

It happens during `pg_dump` when a default-privileges entry is not in the form the tool expects — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server. If the versions match and the entry is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — an unparsable default-privileges entry.

```text
pg_dump: fatal: could not parse default ACL list (=r/postgres)
```

## Related

- [could not parse ACL list or default for object](./could-not-parse-acl-list-or-default-for-object.md)
- [could not parse initial ACL list or default for object](./could-not-parse-initial-acl-list-or-default-for-object.md)
