---
message: "requested length cannot be negative"
slug: requested-length-cannot-be-negative
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:819"
  - "postgres/src/backend/utils/adt/genfile.c:246"
  - "postgres/src/backend/utils/adt/genfile.c:267"
reproduced: true
---

# `requested length cannot be negative`

## What it means

A function that reads or allocates a length of bytes was given a negative length. A byte count must be zero or positive, so a negative value is rejected.

## When it happens

Calling a large-object read, a file-reading function such as `pg_read_binary_file`, or a substring-style byte operation with a length argument that computed to a negative number — often from arithmetic on positions where the end fell before the start.

## How to fix

Ensure the length argument is zero or positive. Check the arithmetic that produced it, clamp it to zero when a computed span could be negative, and validate any length that comes from application input.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT pg_read_binary_file('/nonexistent', 0, -1);
```

Produces:

```text
ERROR:  requested length cannot be negative
```

## Related

- [requested length too large](./requested-length-too-large.md)
- [invalid value for option](./invalid-value-for-option.md)
