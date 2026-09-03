# Korea Historical Economic & Agricultural Archive

This directory is a source-aware annual archive for the Republic of Korea, organized from 1965 through 2026. It mirrors the structured annual research model used elsewhere in this repository while keeping Korean data distinct from other country archives.

## Architecture

Each year contains `META.md`, `INDEX.md`, and twelve domain documents: economy, agriculture, farming statistics, produce, grains, meat, livestock, vegetables, fruit, and water. Documents are intentionally source-led: a value is included only when it can be traced to an identified source. Unverified values are marked `PENDING_SOURCE` or `NOT_AVAILABLE` rather than estimated.

## Primary source families

- KOSIS / Statistics Korea: national statistical tables, including agriculture and forestry, prices, economy and national accounts.
- Ministry of Agriculture, Food and Rural Affairs (MAFRA): agricultural and food statistical yearbooks and administrative statistics.
- KAMIS: agricultural, livestock and fishery market-price information, including annual and historical retail series.
- Bank of Korea: national accounts and macroeconomic statistics.
- FAOSTAT / FAO AQUASTAT: international agriculture and water series used only when the Korean series and definitions are compatible.

## Data posture

This is an archival research structure, not a claim that every annual series has already been completely transcribed. Current verified source availability is recorded in `DATA_SOURCES.md`. Historical extraction should preserve original units, definitions, geographic scope, revisions, and source dates.

## Document contract

Every annual document points to that year's `META.md`. `META.md` is controlling metadata for the annual set. No document may convert an absence of evidence into a factual claim. Analytical scores or models must be explicitly labeled as derived values and must retain the underlying observations.

## Build

The existing C/C++ evaluation module remains at the top level of `korea/`. The annual archive is documentary data, while `data.json`, `congruences.xml`, and `results.xml` remain machine-readable model inputs/outputs.
