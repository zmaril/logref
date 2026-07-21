---
message: "cannot insert into frozen hashtable \"%s\""
slug: cannot-insert-into-frozen-hashtable
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1014"
reproduced: false
---

# `cannot insert into frozen hashtable "%s"`

## What it means

An internal guard in the dynamic hash-table code fired: code tried to insert into a hash table that has been frozen. Freezing marks a hash table read-only so its structure stays fixed, so inserts are refused. The placeholder is the hash table name.

## When it happens

It is reached when a caller inserts into a hash table after freezing it. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or code path managing the hash table and report it, since a frozen hash table must not receive inserts.

## Example

*Illustrative* — insert into a frozen hash table.

```text
ERROR:  cannot insert into frozen hashtable "Relcache by OID"
```

## Related

- [cannot freeze hashtable because it has active scans](./cannot-freeze-hashtable-because-it-has-active-scans.md)
- [cannot freeze shared hashtable](./cannot-freeze-shared-hashtable.md)
