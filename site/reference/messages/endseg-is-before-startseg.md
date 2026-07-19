---
message: "ENDSEG %s is before STARTSEG %s"
slug: endseg-is-before-startseg
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1336"
reproduced: false
---

# `ENDSEG %s is before STARTSEG %s`

## What it means

`pg_waldump` was given an ending WAL segment that comes before the starting segment. The placeholders are the two segment names. The range is empty or reversed.

## When it happens

It fires at `pg_waldump` startup when the `ENDSEG` argument precedes the `STARTSEG` argument in WAL order.

## How to fix

Order the segments so `STARTSEG` comes before `ENDSEG`. Swap them if reversed, and confirm both belong to the same timeline.

## Example

*Illustrative* — reversed WAL segments.

```text
pg_waldump: error: ENDSEG 000000010000000000000001 is before STARTSEG 000000010000000000000005
```

## Related

- [end WAL location is not inside file](./end-wal-location-is-not-inside-file.md)
- [--endpos may only be specified with --start](./endpos-may-only-be-specified-with-start.md)
