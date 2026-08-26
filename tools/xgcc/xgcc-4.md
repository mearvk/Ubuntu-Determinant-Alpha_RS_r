# xgcc-4 — Routing and Continuation

**Author:** Max Rupplin - MEARVK LLC 2026

Generation 4 defines the XGCC routing/continuation contract. An XGCC instance can identify `self` and `next`, then pause and resume through an explicitly requested local or network transport.

Example:

```sh
xgcc net 2 3
```

Network operation requires an explicit host/port. The nominal 60 MB/s profile is a flow-control planning value, not a guaranteed network rate.

Future implementation should use the optional `libxgcc-net.so` capability and keep userland execution first-class.
