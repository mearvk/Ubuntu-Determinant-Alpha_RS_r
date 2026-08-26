# Smaug 386-Library Architecture

Smaug reserves 386 library identities for the White Edition architecture.

The registry is intentionally staged. A library identity is not considered implemented merely because it exists in this document.

## Library families

1. Chess state and legality
2. Castling and transition analysis
3. Search and planning
4. Human training
5. Machine training
6. Experiment control
7. Reversibility and rollback
8. Provenance and evidence
9. Dependency/risk analysis
10. Software aging and lease state
11. Validation and testing
12. Userspace policy
13. Business workflow policy
14. Content hygiene
15. Audit and reporting
16. Numerical/statistical utilities
17. C compatibility
18. C++ orchestration
19. Platform abstraction
20. Future experimental modules

The first milestone is the stable Smaug interface, not filling all 386 slots with speculative code.

## Module contract

Every library should eventually expose or document:

- identity;
- semantic purpose;
- API boundary;
- inputs/outputs;
- threat/risk assumptions;
- provenance;
- test status;
- compatibility;
- rollback behavior.

## Safety rule

No library receives authority merely because its score is high. The fictional Smaug confidence scale is an engineering heuristic and must not be represented as IQ, personality measurement, or human worth.
