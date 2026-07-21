---
message: "access method \"%s\" does not support WITHOUT OVERLAPS constraints"
slug: access-method-does-not-support-without-overlaps-constraints
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:904"
reproduced: false
---

# `access method "%s" does not support WITHOUT OVERLAPS constraints`

## What it means

A `WITHOUT OVERLAPS` clause (temporal primary-key/unique constraint) was requested on an access method that cannot enforce non-overlapping ranges.

## When it happens

It occurs when defining a temporal constraint whose final column uses `WITHOUT OVERLAPS` on an index method that does not support the overlap-exclusion machinery it requires.

## How to fix

Use an access method that supports `WITHOUT OVERLAPS` — GiST is the method that backs temporal (range) exclusion. Change the constraint's index method accordingly.

## Example

*Illustrative* — WITHOUT OVERLAPS on an unsupported method.

```text
ERROR:  access method "btree" does not support WITHOUT OVERLAPS constraints
```

## Related

- [access method does not support exclusion constraints](./access-method-does-not-support-exclusion-constraints.md)
- [access method does not support unique indexes](./access-method-does-not-support-unique-indexes.md)
