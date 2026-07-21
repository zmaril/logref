---
message: "cannot change owner of sequence \"%s\""
slug: cannot-change-owner-of-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:16848"
reproduced: false
---

# `cannot change owner of sequence "%s"`

## What it means

An `ALTER SEQUENCE ... OWNER TO` targeted a sequence whose ownership is tied to a table column — for example a sequence backing a `serial` or identity column. Such a sequence's owner follows the owning table, so it cannot be changed on its own. The placeholder is the sequence name.

## When it happens

It occurs when trying to change the owner of a sequence that is owned by a table column via `OWNED BY`.

## How to fix

Change the owner of the owning table, which the dependent sequence follows. To give the sequence an independent owner, detach it with `ALTER SEQUENCE ... OWNED BY NONE` first.

## Example

*Illustrative* — changing an owned sequence's owner.

```text
ERROR:  cannot change owner of sequence "t_id_seq"
```

## Related

- [cannot change owner of relation](./cannot-change-owner-of-relation.md)
- [cannot change ownership of identity sequence](./cannot-change-ownership-of-identity-sequence.md)
