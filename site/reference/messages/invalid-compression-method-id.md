---
message: "invalid compression method id %d"
slug: invalid-compression-method-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/detoast.c:489"
  - "postgres/src/backend/access/common/detoast.c:532"
  - "postgres/src/backend/utils/adt/varlena.c:4249"
reproduced: false
---

# `invalid compression method id %d`

## What it means

Internal error. A stored value carried a compression-method identifier that Postgres does not recognize while trying to decompress it. The set of TOAST compression methods is fixed and small, so an unknown id means the value's header does not match any known method.

## When it happens

It should not occur when reading data written by a compatible server. Reaching it points to on-disk corruption of a TOASTed value's compression header, or a value produced by an incompatible build, rather than to normal query activity.

## How to fix

Treat it as a data-integrity or version-compatibility problem. Identify the table and column being read, restore the affected value from a backup, and check hardware and storage health. If it appears right after a downgrade, the value was written by a newer format the current server cannot read.

## Example

*Illustrative* — surfaced while decompressing a stored value.

```text
ERROR:  invalid compression method id 7
```

## Related

- [invalid internal value for enum](./invalid-internal-value-for-enum.md)
- [compressed pglz data is corrupt](./compressed-pglz-data-is-corrupt.md)
