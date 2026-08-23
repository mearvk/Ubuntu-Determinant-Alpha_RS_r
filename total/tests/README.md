# Total Native Tests

The first-edition tests establish the basic invariants of the Total domain/evidence boundary.

## Current coverage

`total_domain_test.c` checks:

- valid versioned evidence is accepted;
- missing provenance is rejected;
- failed integrity is rejected;
- expired evidence is rejected.

The test is deliberately small. The next testing layers should cover the input registry, policy-provider behavior, malformed strings, boundary counts (3 and 1000), duplicate input IDs, concurrency, ownership/lifetime, and eventual cryptographic provenance.

Tests should prove both positive and negative behavior. In particular, a domain adapter must not accidentally turn the existence of payment, identity, presence, or historical activity into consent or authorization.

## Intended build

A minimal first-edition build can compile the domain implementation and test with a C11-capable compiler, using `total/include` as the include directory. The repository's authoritative build system should eventually own this command so CI and local development cannot drift apart.

## Status

This is a bootstrap test layer, not production certification. Passing these tests establishes only the documented local invariants.
