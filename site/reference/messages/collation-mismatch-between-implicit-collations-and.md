---
message: "collation mismatch between implicit collations \"%s\" and \"%s\""
slug: collation-mismatch-between-implicit-collations-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
call_sites:
  - "postgres/src/backend/parser/parse_collate.c:226"
  - "postgres/src/backend/parser/parse_collate.c:473"
  - "postgres/src/backend/parser/parse_collate.c:1005"
reproduced: false
---

# `collation mismatch between implicit collations "%s" and "%s"`

## What it means

An expression combined two values whose collations were both derived implicitly (from their columns) but differ, and no explicit collation was given to break the tie. The placeholders name the two collations. When collation matters and the inputs disagree without an explicit choice, the result collation is ambiguous, so it is an error.

## When it happens

Comparing or concatenating two columns declared with different collations in a context that needs one collation (an equality, ordering, or pattern match), without an explicit `COLLATE`.

## How to fix

Resolve the ambiguity with an explicit `COLLATE` clause on one side — for example `a = b COLLATE "en_US"` — choosing the collation the comparison should use. Alternatively, align the columns' collations in the schema so they no longer conflict.

## Example

*Illustrative* — two implicit collations in conflict.

```sql
SELECT a = b FROM t;  -- collation mismatch between implicit collations "en_US" and "C"
```

## Related

- [could not determine which collation to use for string comparison](./could-not-determine-which-collation-to-use-for-string-comparison.md)
- [pg_strnxfrm returned unexpected result](./pg-strnxfrm-returned-unexpected-result.md)
