---
message: "could not parse ACL list (%s) for tablespace \"%s\""
slug: could-not-parse-acl-list-for-tablespace
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1430"
reproduced: false
---

# `could not parse ACL list (%s) for tablespace "%s"`

## What it means

`pg_dumpall` read a stored access-control list for a tablespace and could not parse it. The `%s` values give the raw ACL text and the tablespace name. It parses ACLs to reproduce grants in the dump.

## When it happens

It happens during `pg_dumpall` when a tablespace's ACL text is not in the form the tool expects — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dumpall` whose version matches (or is newer than) the server. If the versions match and the ACL is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — an unparsable tablespace ACL.

```text
pg_dumpall: error: could not parse ACL list (=/postgres) for tablespace "fastspace"
```

## Related

- [could not parse ACL list for parameter](./could-not-parse-acl-list-for-parameter.md)
- [could not parse ACL list or default for object](./could-not-parse-acl-list-or-default-for-object.md)
