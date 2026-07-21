---
message: "requested length too large"
slug: requested-length-too-large
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/genfile.c:112"
  - "postgres/src/backend/utils/adt/oracle_compat.c:204"
  - "postgres/src/backend/utils/adt/oracle_compat.c:302"
  - "postgres/src/backend/utils/adt/oracle_compat.c:862"
  - "postgres/src/backend/utils/adt/oracle_compat.c:1165"
reproduced: true
---

# `requested length too large`

## What it means

A function asked to read or allocate a length that exceeds an allowed maximum. The message covers cases like `pg_read_file`/`pg_read_binary_file` with an excessive length, where the request would exceed the 1 GB per-value limit or another bound.

## When it happens

Calling a file- or memory-returning function with a length argument larger than the maximum size of the resulting value, or requesting more data than the 1 GB field-size limit permits.

## How to fix

Request a smaller length, or read the data in chunks using the offset/length arguments (for example repeated `pg_read_binary_file(path, offset, length)` calls). No single returned value may exceed the 1 GB limit, so large files must be read piecewise.

## Example

*Reproduced* — captured from `reproducers/scenarios/17_strings_format_regex.sql`.

```sql
SELECT rpad('x', 2000000000, 'yyyy');
```

Produces:

```text
ERROR:  requested length too large
```

## Related

- [cannot pass more than argument to a function](./cannot-pass-more-than-argument-to-a-function.md)
- [could not map dynamic shared memory segment](./could-not-map-dynamic-shared-memory-segment.md)
