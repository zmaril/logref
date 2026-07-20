---
message: "could not find enum option %d for %s"
slug: could-not-find-enum-option-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:2935"
reproduced: false
---

# `could not find enum option %d for %s`

## What it means

The GUC (configuration-parameter) machinery could not match a stored numeric value back to a named option of an enum parameter. The `%d` and `%s` give the value and parameter. This is an internal consistency check.

## When it happens

It fires while formatting or transferring an enum-valued setting when the internal value does not correspond to any of the parameter's defined options. Ordinary configuration does not reach it.

## How to fix

This is an internal error. If it appears, note the parameter named in the message and how it was set (including any extension that defines custom enum parameters), and report a reproducible case.

## Example

*Illustrative* — an enum setting value with no matching option.

```text
ERROR:  could not find enum option 9 for my_setting
```

## Related

- [could not find custom name for wait event information](./could-not-find-custom-name-for-wait-event-information.md)
- [could not find null terminator in GUC state](./could-not-find-null-terminator-in-guc-state.md)
