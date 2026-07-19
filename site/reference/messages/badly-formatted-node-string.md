---
message: "badly formatted node string \"%.32s\"..."
slug: badly-formatted-node-string
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:594"
reproduced: false
---

# `badly formatted node string "%.32s"...`

## What it means

The node-tree reader was handed a serialized plan or expression string it could not parse. The placeholder shows the first characters of the offending string. Node strings are the on-disk and internal representation of parse and plan trees.

## When it happens

It occurs when a stored node string is read back and does not conform to the expected grammar — for example a corrupted catalog column that stores an expression, or a value produced by an incompatible version.

## How to fix

Identify where the node string was stored. If it is a catalog entry such as a rule, default, or check expression, the object may be corrupt or version-mismatched; recreate it. Reading node strings produced by a different major version is not supported.

## Example

*Illustrative* — an unparsable node string.

```text
ERROR:  badly formatted node string "{QRY :commandType..."
```

## Related

- [bogus resno in targetlist](./bogus-resno-in-targetlist.md)
- [bad dumpid](./bad-dumpid.md)
