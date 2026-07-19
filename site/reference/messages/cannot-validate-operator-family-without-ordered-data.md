---
message: "cannot validate operator family without ordered data"
slug: cannot-validate-operator-family-without-ordered-data
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/amvalidate.c:54"
reproduced: false
---

# `cannot validate operator family without ordered data`

## What it means

An internal guard fired during operator-family validation: the code needed ordered index data to check the family's operators but the access method did not provide it. The validation path expects ordered scans, so this state should not arise for a well-formed access method.

## When it happens

It is reached from `ALTER OPERATOR FAMILY` validation or `amvalidate` for an access method whose ordering support is incomplete. It usually points to an extension access method rather than a user action.

## How to fix

There is no user-level fix in core SQL. If it appears with a custom access method, report it to that extension's author; the access method must supply ordered scan support for validation.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot validate operator family without ordered data
```

## Related

- [cannot verify that tuples from index can each be found by an independent index search](./cannot-verify-that-tuples-from-index-can-each-be-found-by-an-independent-index.md)
- [cannot validate constraint of relation](./cannot-validate-constraint-of-relation.md)
