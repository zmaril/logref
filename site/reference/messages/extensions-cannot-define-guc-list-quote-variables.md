---
message: "extensions cannot define GUC_LIST_QUOTE variables"
slug: extensions-cannot-define-guc-list-quote-variables
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4804"
reproduced: false
---

# `extensions cannot define GUC_LIST_QUOTE variables`

## What it means

An internal restriction on custom configuration variables. When an extension defines a GUC (configuration parameter), it may not mark that variable with the internal list-quote flag, which is reserved for a small set of built-in list parameters. It concerns extension development.

## When it happens

It fires at server startup or extension load when a module registers a custom string GUC using the list-quote behaviour that only built-in variables are permitted to use.

## How to fix

This is a limit for extension authors. Define the custom variable without the list-quote flag; use a plain string GUC and parse the list yourself. If you are only using an extension that triggers this, report it to the extension's author. There is no server-side configuration for it.

## Example

*Illustrative* — the message as logged.

```
FATAL:  extensions cannot define GUC_LIST_QUOTE variables
```

## Related

- [`extensible node name is too long`](./extensible-node-name-is-too-long.md)
- [ExtensibleNodeMethods was not registered](./extensiblenodemethods-was-not-registered.md)
