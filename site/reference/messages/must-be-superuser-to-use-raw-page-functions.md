---
message: "must be superuser to use raw page functions"
slug: must-be-superuser-to-use-raw-page-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/pageinspect/brinfuncs.c:52"
  - "postgres/contrib/pageinspect/brinfuncs.c:145"
  - "postgres/contrib/pageinspect/brinfuncs.c:355"
  - "postgres/contrib/pageinspect/brinfuncs.c:395"
  - "postgres/contrib/pageinspect/btreefuncs.c:742"
  - "postgres/contrib/pageinspect/fsmfuncs.c:44"
  - "postgres/contrib/pageinspect/ginfuncs.c:40"
  - "postgres/contrib/pageinspect/ginfuncs.c:110"
  - "postgres/contrib/pageinspect/ginfuncs.c:186"
  - "postgres/contrib/pageinspect/gistfuncs.c:87"
  - "postgres/contrib/pageinspect/gistfuncs.c:142"
  - "postgres/contrib/pageinspect/gistfuncs.c:212"
  - "postgres/contrib/pageinspect/hashfuncs.c:201"
  - "postgres/contrib/pageinspect/hashfuncs.c:249"
  - "postgres/contrib/pageinspect/hashfuncs.c:314"
  - "postgres/contrib/pageinspect/hashfuncs.c:414"
  - "postgres/contrib/pageinspect/hashfuncs.c:534"
  - "postgres/contrib/pageinspect/heapfuncs.c:138"
  - "postgres/contrib/pageinspect/heapfuncs.c:451"
  - "postgres/contrib/pageinspect/heapfuncs.c:528"
  - "postgres/contrib/pageinspect/rawpage.c:154"
  - "postgres/contrib/pageinspect/rawpage.c:262"
  - "postgres/contrib/pageinspect/rawpage.c:346"
reproduced: true
---

# `must be superuser to use raw page functions`

## What it means

A `pageinspect` function that reads raw on-disk page images was called by a role without superuser rights. These functions expose byte-level page contents and can be used to probe data outside normal access checks, so they are restricted.

## When it happens

Calling `get_raw_page`, `heap_page_items`, `bt_page_items`, or similar `pageinspect` functions as a non-superuser. It appears during low-level debugging or corruption investigation done by an unprivileged role.

## How to fix

Run these functions as a superuser, or have a superuser `GRANT EXECUTE` on the specific functions to a trusted role (recent versions allow granting execute on some inspection functions to non-superusers). Do not grant broadly — raw page access bypasses row-level protections. If you only need normal data, use ordinary SQL instead.

## Example

*Reproduced* — captured from `reproducers/scenarios/64_contrib_inspect_deep.sql`.

```sql
SELECT get_raw_page('repro.parent', 0);
```

Produces:

```text
ERROR:  must be superuser to use raw page functions
```

## Related

- [must be superuser to use pgstattuple functions](./must-be-superuser-to-use-pgstattuple-functions.md)
- [permission denied: is a system catalog](./permission-denied-is-a-system-catalog.md)
