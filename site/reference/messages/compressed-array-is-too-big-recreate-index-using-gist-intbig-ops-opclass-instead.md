---
message: "compressed array is too big, recreate index using gist__intbig_ops opclass instead"
slug: compressed-array-is-too-big-recreate-index-using-gist-intbig-ops-opclass-instead
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/intarray/_int_gist.c:337"
reproduced: false
---

# `compressed array is too big, recreate index using gist__intbig_ops opclass instead`

## What it means

The `intarray` GiST index tried to store a compressed integer-array key that exceeds the size limit for the `gist__int_ops` opclass. The message advises switching to the signature-based `gist__intbig_ops` opclass, which handles large arrays.

## When it happens

It happens with an `intarray` GiST index using `gist__int_ops` when an indexed array is large enough that its compressed form overflows a page.

## How to fix

Recreate the index with the `gist__intbig_ops` opclass, which represents keys as fixed-size signatures suited to large arrays: `CREATE INDEX ... USING gist (col gist__intbig_ops)`.

## Example

*Illustrative* — an oversize array under gist__int_ops.

```sql
CREATE INDEX ON t USING gist (arr gist__int_ops);
-- ERROR:  compressed array is too big, recreate index using gist__intbig_ops opclass instead
```

## Related

- [compress method must be defined when leaf type is different from input type](./compress-method-must-be-defined-when-leaf-type-is-different-from-input-type.md)
- [compression detail cannot be specified unless compression is enabled](./compression-detail-cannot-be-specified-unless-compression-is-enabled.md)
