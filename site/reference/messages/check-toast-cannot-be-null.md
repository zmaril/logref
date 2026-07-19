---
message: "check_toast cannot be null"
slug: check-toast-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/amcheck/verify_heapam.c:285"
reproduced: false
---

# `check_toast cannot be null`

## What it means

A function in the amcheck extension was called with a null value for its `check_toast` argument. That argument selects whether to verify TOASTed values and must be a concrete boolean, so a null is rejected.

## When it happens

It occurs when an amcheck verification function, such as `verify_heapam()`, is passed `check_toast => NULL`.

## How to fix

Pass `true` or `false` for `check_toast`. Supply an explicit boolean rather than `NULL` for that argument.

## Example

*Illustrative* — a null check_toast argument.

```sql
SELECT verify_heapam('t', check_toast => NULL);
-- ERROR:  check_toast cannot be null
```

## Related

- [column filter expression must not be null](./column-filter-expression-must-not-be-null.md)
- [checksum verification failure during base backup](./checksum-verification-failure-during-base-backup.md)
