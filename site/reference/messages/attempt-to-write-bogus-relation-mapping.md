---
message: "attempt to write bogus relation mapping"
slug: attempt-to-write-bogus-relation-mapping
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:911"
reproduced: false
---

# `attempt to write bogus relation mapping`

## What it means

The relation-mapping subsystem was about to write a mapping file whose contents failed its own sanity check, so it refused to persist a map it considers invalid — an internal consistency guard.

## When it happens

It is raised when updating the map that tracks the filenodes of mapped system catalogs, if the in-memory map fails validation before being written, normally only through a bug or memory corruption.

## How to fix

This is an internal error that touches critical catalog bookkeeping. Do not ignore it: capture the log, stop making changes, and treat catalog integrity as suspect. Investigate for corruption and restore from a known-good backup if needed; report it with the surrounding context.

## Example

*Illustrative* — a failed relation-map validation before write.

```text
ERROR:  attempt to write bogus relation mapping
```

## Related

- [attempt to apply a mapping to unmapped relation](./attempt-to-apply-a-mapping-to-unmapped-relation.md)
- [allocatedesc kind not recognized](./allocatedesc-kind-not-recognized.md)
