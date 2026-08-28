# Gradle Boot-to-Desktop Synthesizer Icon Set

## Desktop icon source

The desktop icons for the **Gradle boot-to-Desktop synthesizer** are designated to use the existing `set-001` icon set:

`images/desktop-icons/set-001/`

The set currently contains the individual PNG assets `icon-001.png` through `icon-012.png`.

## Integration note

The Gradle boot-to-Desktop synthesizer should use these icons as its desktop/application icon assets rather than introducing a second icon family. Preserve the source artwork and transparency when packaging for the target desktop platforms.

## Repository search status

A repository code search was performed for `gradle`, `synthesizer`, and the combined `gradle boot desktop synthesizer` terms. No matching implementation was returned by the repository code-search index at the time of this note.

Therefore, the synthesizer implementation/location has **not yet been identified** in the repository. This document records the intended icon dependency so that the implementation can be connected to `set-001` when the Gradle boot-to-Desktop synthesizer is located or added.

## Intended relationship

```text
Gradle boot-to-Desktop synthesizer
        |
        +--> desktop/application icon assets
                 |
                 +--> images/desktop-icons/set-001/icon-001.png
                 +--> images/desktop-icons/set-001/icon-002.png
                 +--> ...
                 +--> images/desktop-icons/set-001/icon-012.png
```

This is an implementation note, not a claim that the synthesizer is already present.
