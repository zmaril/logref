---
message: "could not parse ACL list (%s) for parameter \"%s\""
slug: could-not-parse-acl-list-for-parameter
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1303"
reproduced: false
---

# `could not parse ACL list (%s) for parameter "%s"`

## What it means

`pg_dumpall` read a stored access-control list for a configuration parameter and could not parse it. The `%s` values give the raw ACL text and the parameter name. It parses ACLs to reproduce grants in the dump.

## When it happens

It happens during `pg_dumpall` when a parameter's ACL text is not in the form the tool expects — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dumpall` whose version matches (or is newer than) the server being dumped, since newer ACL formats can confuse an older tool. If the versions already match and the ACL is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — an unparsable parameter ACL.

```text
pg_dumpall: error: could not parse ACL list (=r/postgres) for parameter "work_mem"
```

## Related

- [could not parse ACL list for tablespace](./could-not-parse-acl-list-for-tablespace.md)
- [could not parse default ACL list](./could-not-parse-default-acl-list.md)
