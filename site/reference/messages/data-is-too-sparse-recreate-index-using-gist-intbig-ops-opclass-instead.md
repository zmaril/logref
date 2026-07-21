---
message: "data is too sparse, recreate index using gist__intbig_ops opclass instead"
slug: data-is-too-sparse-recreate-index-using-gist-intbig-ops-opclass-instead
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/intarray/_int_gist.c:275"
reproduced: false
---

# `data is too sparse, recreate index using gist__intbig_ops opclass instead`

## What it means

An `intarray` GiST index using the small signature operator class could not represent the data well because it is too sparse. The extension advises switching to the big-signature operator class, which handles sparse integer sets better.

## When it happens

It happens while building or updating an `intarray` GiST index declared with the `gist__int_ops` operator class over data whose value distribution the compact signature cannot handle.

## How to fix

Recreate the index with the `gist__intbig_ops` operator class as the message advises, for example `CREATE INDEX ... USING gist (col gist__intbig_ops)`. That operator class uses a larger signature suited to sparse or high-cardinality integer arrays.

## Example

*Illustrative* — the compact signature could not fit the data.

```text
ERROR:  data is too sparse, recreate index using gist__intbig_ops opclass instead
```

## Related

- [cube dimension is too large](./cube-dimension-is-too-large.md)
- [data type is not an array type](./data-type-is-not-an-array-type.md)
