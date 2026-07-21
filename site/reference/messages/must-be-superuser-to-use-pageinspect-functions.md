---
message: "must be superuser to use pageinspect functions"
slug: must-be-superuser-to-use-pageinspect-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:275"
  - "postgres/contrib/pageinspect/btreefuncs.c:352"
  - "postgres/contrib/pageinspect/btreefuncs.c:634"
  - "postgres/contrib/pageinspect/btreefuncs.c:854"
reproduced: true
---

# `must be superuser to use pageinspect functions`

## What it means

A `pageinspect` function was called by a role that is not a superuser. The `pageinspect` extension exposes raw page and tuple bytes, which can leak data across privilege boundaries and can crash the backend if pointed at the wrong page, so its functions are restricted to superusers.

## When it happens

Calling `get_raw_page`, `heap_page_items`, `bt_page_items`, or another `pageinspect` function from an ordinary or merely privileged role rather than a superuser.

## How to fix

Run the `pageinspect` call as a superuser, or have a superuser wrap the specific inspection you need in a `SECURITY DEFINER` function and grant `EXECUTE` on that wrapper to the intended role. Do not grant broad `pageinspect` access to untrusted roles — the raw-byte access it provides is deliberately privileged.

## Example

*Reproduced* — captured from `reproducers/scenarios/64_contrib_inspect_deep.sql`.

```sql
SELECT bt_metap('repro.big_pkey');
```

Produces:

```text
ERROR:  must be superuser to use pageinspect functions
```

## Related

- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
- [cannot access temporary indexes of other sessions](./cannot-access-temporary-indexes-of-other-sessions.md)
