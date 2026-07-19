---
message: "cannot freeze hashtable \"%s\" because it has active scans"
slug: cannot-freeze-hashtable-because-it-has-active-scans
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1469"
reproduced: false
---

# `cannot freeze hashtable "%s" because it has active scans`

## What it means

An internal guard in the dynamic hash-table code fired: code tried to freeze a hash table that still has active sequential scans. Freezing locks the table's structure, which would break an in-progress scan, so it is refused. The placeholder is the hash table name.

## When it happens

It is reached when internal code freezes a shared or local hash table while a `hash_seq_search` scan over it is still open. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the workload and any extension that manages hash tables and report it, since the caller must finish or release its scans before freezing.

## Example

*Illustrative* — freeze attempted during an active scan.

```text
ERROR:  cannot freeze hashtable "Portal hash" because it has active scans
```

## Related

- [cannot freeze shared hashtable](./cannot-freeze-shared-hashtable.md)
- [cannot insert into frozen hashtable](./cannot-insert-into-frozen-hashtable.md)
