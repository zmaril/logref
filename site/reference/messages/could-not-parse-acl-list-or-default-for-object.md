---
message: "could not parse ACL list (%s) or default (%s) for object \"%s\" (%s)"
slug: could-not-parse-acl-list-or-default-for-object
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:16433"
reproduced: false
---

# `could not parse ACL list (%s) or default (%s) for object "%s" (%s)`

## What it means

`pg_dump` read a stored access-control list, or a default-privilege entry, for an object and could not parse it. The `%s` values give the ACL text, the default text, and the object's name and type. It parses these to reproduce grants.

## When it happens

It happens during `pg_dump` when an object's ACL or default-privilege text is not in the form the tool expects — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions already match and the entry is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — an unparsable object ACL.

```text
pg_dump: fatal: could not parse ACL list (=r/postgres) or default (none) for object "orders" (TABLE)
```

## Related

- [could not parse initial ACL list or default for object](./could-not-parse-initial-acl-list-or-default-for-object.md)
- [could not parse default ACL list](./could-not-parse-default-acl-list.md)
