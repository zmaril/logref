---
message: "component in parameter \"%s\" is not an absolute path"
slug: component-in-parameter-is-not-an-absolute-path
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/commands/extension.c:4109"
  - "postgres/src/backend/utils/fmgr/dfmgr.c:623"
reproduced: false
---

# `component in parameter "%s" is not an absolute path`

## What it means

A configuration parameter that must hold an absolute path was given a value containing a relative component. The placeholder is the parameter name. Path settings such as those for extensions or dynamic libraries must be absolute so they resolve independently of the working directory.

## When it happens

Setting a path-valued parameter (for example `dynamic_library_path` or an extension control path) to a value with a relative segment, or with a component that does not begin at the filesystem root.

## How to fix

Provide fully absolute paths for every component of the parameter. Replace relative segments with absolute ones, and use the documented placeholders (such as `$libdir`) where the parameter supports them. Reload or restart so the corrected value takes effect.

## Example

*Illustrative* — a relative component in a path parameter.

```text
ERROR:  component in parameter "dynamic_library_path" is not an absolute path
```

## Related

- [could not change directory to](./could-not-change-directory-to-7fbc5f.md)
- [cannot set parameter within security-restricted operation](./cannot-set-parameter-within-security-restricted-operation.md)
