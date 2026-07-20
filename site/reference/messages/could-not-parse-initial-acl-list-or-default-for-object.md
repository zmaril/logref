---
message: "could not parse initial ACL list (%s) or default (%s) for object \"%s\" (%s)"
slug: could-not-parse-initial-acl-list-or-default-for-object
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:16408"
reproduced: false
---

# `could not parse initial ACL list (%s) or default (%s) for object "%s" (%s)`

## What it means

`pg_dump` read the initial (extension-provided) access-control list, or default-privilege entry, for an object and could not parse it. The `%s` values give the ACL text, the default text, and the object's name and type.

## When it happens

It happens during `pg_dump` when an object's initial ACL — the privileges recorded when an extension created it — is not in the expected form, usually a version mismatch between the dumping tool and the server.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions match and the entry is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — an unparsable initial ACL.

```text
pg_dump: fatal: could not parse initial ACL list (=r/postgres) or default (none) for object "my_view" (VIEW)
```

## Related

- [could not parse ACL list or default for object](./could-not-parse-acl-list-or-default-for-object.md)
- [could not parse default ACL list](./could-not-parse-default-acl-list.md)
