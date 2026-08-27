# Smaug Emerald 3D Routing AI

## Concept

**Emerald** is Smaug's bounded stereoscopic routing model. It represents a
moving field as three-dimensional units with a compass carrying position,
direction, time-unit, and identity.

The model combines ideas from a sifted network, neural routing, and a compass:

- **Neurons** occupy 3-D positions and carry activation/state.
- **Compass** represents where an entity is, where it is moving, and its
  observed time unit.
- **Stereoscopic/unit perception** means the field is represented as discrete
  spatial units while retaining a three-axis perspective.
- **Ready** is the stable state from which a decision can be evaluated.
- **Decide** selects a bounded route outcome.
- **An / And** are intentionally small routing tokens: `An` selects a single
  link; `And` represents a joined link.

## Movement and terminal state

Entities may move through the modeled field and consume a finite move budget.
When the budget reaches zero, the entity becomes `Exhausted` and then
`Terminal`. Likewise, complete coverage can produce a terminal routing result.

These are **simulation states only**. Emerald does not direct harm against
people, animals, or real-world opponents.

## Coverage / Deathly boundary

The requested "Deathly" concept is represented technically as the **terminal
coverage boundary**: when the modeled field has no remaining useful coverage,
or an entity has no remaining moves, that entity leaves the active simulation
field.

No real-world lethal action is implied.

## Compass and time

The compass is not merely geographic. It is a state coordinate:

```text
(position, direction, time_unit, identity)
```

This lets Smaug compare successive observations of a moving entity without
confusing spatial movement with a change of identity.

## Schedule

`ScheduleEntry` provides the proposed database/schedule boundary. A scheduler
can persist these entries, replay them, audit them, or reject them. The routing
engine itself does not silently grant authority to execute a scheduled action.

## Relationship to Castle

Emerald is downstream of Smaug's Castle/INCLARE boundary. External observations
remain observations. A model result is a proposal until it passes the relevant
policy, evidence, and authority gates.

## Implementation

- `SmaugEmerald.hpp` — public 3-D routing model.
- `SmaugEmerald.cpp` — bounded implementation.

The implementation intentionally favors deterministic state transitions and
explicit terminal conditions over an opaque autonomous controller.
