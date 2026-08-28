# Ubuntu White — Icon Greeting 2

## Desktop Greeting — Set 001

This document extends the Ubuntu White icon greeting to the **12-icon desktop set** used by the Gradle boot-to-Desktop synthesizer.

The source of truth for this desktop set is:

`images/desktop-icons/set-001/`

The twelve referenced desktop icons are:

| # | Icon | Source |
|---:|---|---|
| 1 | Desktop Icon 001 | `images/desktop-icons/set-001/icon-001.png` |
| 2 | Desktop Icon 002 | `images/desktop-icons/set-001/icon-002.png` |
| 3 | Desktop Icon 003 | `images/desktop-icons/set-001/icon-003.png` |
| 4 | Desktop Icon 004 | `images/desktop-icons/set-001/icon-004.png` |
| 5 | Desktop Icon 005 | `images/desktop-icons/set-001/icon-005.png` |
| 6 | Desktop Icon 006 | `images/desktop-icons/set-001/icon-006.png` |
| 7 | Desktop Icon 007 | `images/desktop-icons/set-001/icon-007.png` |
| 8 | Desktop Icon 008 | `images/desktop-icons/set-001/icon-008.png` |
| 9 | Desktop Icon 009 | `images/desktop-icons/set-001/icon-009.png` |
| 10 | Desktop Icon 010 | `images/desktop-icons/set-001/icon-010.png` |
| 11 | Desktop Icon 011 | `images/desktop-icons/set-001/icon-011.png` |
| 12 | Desktop Icon 012 | `images/desktop-icons/set-001/icon-012.png` |

## Gradle Boot-to-Desktop Reference

The twelve images above are designated as the desktop icon assets for the new **Gradle boot-to-Desktop synthesizer**. A Java-based desktop profile may use this document as the visual asset reference when constructing the desktop presentation.

The synthesizer should reference the repository assets rather than creating substitute artwork. The set is therefore treated as a stable visual input to the desktop profile.

## Ubuntu White Presentation

The desktop presentation continues the Ubuntu White principles established by `IconGreeting.md`:

- clear, quiet desktop presentation;
- generous visual space;
- recognizable icon silhouettes;
- practical rendering at desktop sizes;
- direct repository provenance for the source artwork;
- Java/Gradle compatibility for the desktop synthesizer.

## Relationship to IconGreeting.md

`IconGreeting.md` remains the original Ubuntu White greeting and icon-language document. This **IconGreeting2.md** document is its incremental desktop-set companion and specifically records the twelve `set-001` PNG assets.

## Asset Provenance

The twelve files are maintained under `images/desktop-icons/set-001/` on the repository `main` branch. The set contains `icon-001.png` through `icon-012.png`.

No claim is made here that these assets are official Ubuntu or GNOME artwork. They are repository project assets intended for the Ubuntu White desktop presentation.
