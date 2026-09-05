# wagyu/ — Wagyu master data register

This folder holds the master data register for **Wagyu (the product)** and the
tooling to populate it.

## Files

```text
wagyu/
├── README.md         ← this file
├── WAGYU.MASTER.md   ← GENERATED register (195 countries × 22 fields × 25 years)
├── wagyu.data.csv    ← the DATA source of truth (edit this to populate values)
└── build_wagyu.py    ← regenerates WAGYU.MASTER.md from wagyu.data.csv
```

## The model

- **Economic unit:** one kilogram of graded Wagyu carcass-weight beef (kg cwt), in USD.
- **Wagyu Intrinsic Series (canonical):** 19 core points (F01–F19, frozen) plus a
  declared extension block (F20–F22), i.e. **19+**. Codes are fixed and
  append-only. Full definitions are in `WAGYU.MASTER.md` §2.
- **Coordinate:** every value is indexed by `(country, year, field)` with
  `year ∈ 2002..2026` and 195 countries. That is `22 × 25 × 195 = 107,250` cells.

## Golden rule

**Do not hand-edit values in `WAGYU.MASTER.md`.** It is generated. Edit
`wagyu.data.csv` and regenerate. No value is ever invented: a cell is populated
only if the CSV supplies one, otherwise it is `NR*` (Not Reported).

## How to populate

1. Open `wagyu.data.csv`. Add one row per cell you have data for:

   ```csv
   country,year,field,value,source
   Japan,2023,F13,9800,MAFF-2023
   Australia,2022,F12,1850,AWA-annual-2022
   ```

   - `country` must exactly match the canonical list in `build_wagyu.py`.
   - `field` is a series code `F01`–`F22`.
   - `year` is `2002`–`2026`.
   - `value` is the text to show in the cell (blank ⇒ the cell stays `NR*`).
   - `source` is a short tag; it renders as `value [source]`. Leave blank if none.
   - Lines starting with `#` and blank lines are ignored.

2. Regenerate:

   ```sh
   python3 wagyu/build_wagyu.py
   ```

   It prints how many cells were populated vs. `NR*`, and **fails loudly** on an
   unknown country, bad field code, or out-of-range year (so typos never vanish
   silently).

3. Commit **both** `wagyu.data.csv` and the regenerated `wagyu/WAGYU.MASTER.md`.

## Seeded values and sourcing

The CSV ships pre-seeded with the figures that a source sweep could actually
find (Japan, Australia, United States). Everything else is `NR*`. The reason so
much is unreported: "Wagyu" is a cattle *breed set*, not a customs commodity
code, so FAOSTAT / UN Comtrade / national agencies record *beef*, not *Wagyu*,
and no public source publishes the full per-country/per-year series. In the
authoring environment, direct fetches of primary sites returned HTTP 403, so
seeded values were captured from indexed search-result snippets.

### Sources for seeded values

- **S3 / S17** — JLEC / note.com (Asahi Trading): Japan 2024 beef exports ¥64.8bn, 10,826 t; US+Canada ≈ 23% of value.
- **S4** — Australian Wagyu Association: largest exporter; boxed value AUD ~2.0bn (2023); ~80% exported to 40+ countries.
- **S5** — AWA International Wagyu Office Fact Sheet (2024): ~1,200 members (450 international).
- **S7b** — Nippon.com: Japan beef ¥64.8bn record; top markets US/Taiwan/Hong Kong.
- **S9** — AWA: >25,000 calves added to the database per year.
- **S14** — JIRCAS (JARQ): 1,368,800 Wagyu cattle in Japan.
- **S15** — Wikipedia (Wagyu): Japanese Black >90% of Japan's Wagyu.
- **S16** — ResearchGate: Japanese Wagyu industry review; intramuscular fat >30%.
- **S18** — AWA Ten-Year-Trends: 104,222 registered dams; 12,224 sires (to 2015).
- **S19** — AWA (Member Services Officer posting): >40,000 new calves/yr.
- **S20** — AWA (partners): >1,500 members incl. >650 international (2025).
- **S21** — AWA ("Continued success…"): genomics database >400,000 individuals.
- **S22** — Good Ranchers (citing AWA): <5,000 Fullblood Wagyu in the US (~2022).
- **S23** — AZ Central: American Wagyu Association >900 members (2021).

Where a `~US$` conversion is shown it is approximate (period FX) and flagged `*`.
Market-size aggregates from forecasters (Fortune, Straits, Mordor, 360iResearch)
are context only and disagree with each other; they are not written into
country cells.

*Content from external sources was rephrased/summarised for compliance.*

## Suggested next data feeds

To move cells from `NR*` to real values (in an environment with internet):

- **National herdbooks** — AWA (Australia), American/Canadian/European Wagyu
  associations: registered head, dams, sires, calves, membership.
- **Japan MAFF / JLEC** — export volume/value by destination (F13–F15).
- **UN Comtrade / FAOSTAT** — beef trade proxies (flag clearly as beef-proxy, not
  Wagyu-specific, in the `source` column).
