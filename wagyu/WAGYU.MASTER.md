# WAGYU.MASTER.md — Master Data Register for Wagyu (the product)

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Intrinsic Series ASSIGNED (canonical) — GENERATED FROM wagyu.data.csv

> **This file is generated.** Do not edit values here by hand. Edit
> `wagyu/wagyu.data.csv`, then run `python3 wagyu/build_wagyu.py`. See
> `wagyu/README.md`.

---

## 0. Data-integrity contract

Master data register, one rule: **no value is invented and then presented as
measured fact.** Values come only from `wagyu.data.csv`; blank/absent cells are
`NR*` (Not Reported). "Wagyu" is a cattle *breed set*, not a customs commodity
code, so most public statistics record *beef*, not *Wagyu* — hence most cells
are `NR*` until a reviewed data feed fills them.

## 0a. Institutional basis (UN / FAO) and legal-first caveat

**Law first.** This register is prepared in an ICC/UN-facing context; legal
review precedes any reliance and no ICC/UN endorsement of any figure herein is
asserted or implied.

**UN Charter — economic/statistical mandate (public):** the *Charter of the
United Nations* (public, free at `un.org/en/about-us/un-charter/full-text`)
establishes, in **Chapter IX (Arts. 55–60, incl. Art. 55)** and via **ECOSOC
(Ch. X, Arts. 61–72)**, a mandate to promote higher standards of living and
economic and social development; the UN *Repertory of Practice* for Article 55
expressly covers "administrative, fiscal, legislative and **statistical**
matters."

**UN / FAO — active cattle & Wagyu tracking:** the UN, through the FAO
(`fao.org/statistics`), tracks cattle globally — **FAOSTAT** (inventories,
production, slaughter, ~200 countries), **Gridded Livestock of the World (GLW)**
(spatial distribution), **GLEAM** (herd/environment) — and documents **Wagyu at
breed level** in **DAD-IS** (Japanese Black/Kuroge Washu, Japanese Brown/Akaushi,
Japanese Shorthorn/Nihon Tankaku Washu, Japanese Polled/Mukaku Washu) and the
*State of the World's Animal Genetic Resources* reports.

**Boundary:** the Charter is the enabling economic/statistical mandate; FAO
systems are the real cattle/Wagyu tracking; OECD–FAO/USDA series establish
cattle/beef as a world economic commodity. **None publishes a per-country Wagyu
head census, and none endorses any value in this register.** Cells are sourced
where reported and `NR*` otherwise. See `wagyu/SOULFUL.md` §UN Charter / §UN-FAO
for the full reference and link series.

## 1. The economic unit of Wagyu (the product)

> **one kilogram of graded Wagyu carcass-weight beef (kg cwt)** — cattle
> registered/graded as Wagyu, valued in **USD** at the wholesale/boxed point of
> sale. Head- and herd-based fields are recorded alongside because the carcass
> unit derives from them.

## 2. The Wagyu Intrinsic Series (the 19+ data points) — CANONICAL

The canonical, invariant set of points recorded at every `(country, year)`
coordinate. 19 **core** points (I-19, frozen) plus a declared **extension
block** (E-series), so the series is explicitly **19+**; extension is
append-only and the core codes are never renumbered.

**Core intrinsic series — I-19 (F01–F19):**


- **F01** — Registered Wagyu / Wagyu-influenced cattle (head)
- **F02** — Fullblood/purebred share of registered herd (%)
- **F03** — Wagyu females of breeding age / registered dams (head)
- **F04** — Calves registered in year (head)
- **F05** — Head slaughtered / turned off for Wagyu beef (head)
- **F06** — Carcass production (tonnes cwt)
- **F07** — Average carcass weight (kg cwt)
- **F08** — Average marbling / intramuscular fat
- **F09** — Farmgate price (USD/head)
- **F10** — Wholesale carcass price (USD/kg cwt)
- **F11** — Retail premium vs commodity beef (x multiple)
- **F12** — Boxed-beef production value (USD million)
- **F13** — Export volume (tonnes)
- **F14** — Export value (USD million)
- **F15** — Average export unit price (USD/kg)
- **F16** — Import volume (tonnes)
- **F17** — Import value (USD million)
- **F18** — Domestic Wagyu consumption (tonnes)
- **F19** — Registered Wagyu breeders / seedstock members / DB individuals

**Extension block — E-series (the "+"; reserved & appended):**

- **F20** — Herd growth rate, year-on-year (%)
- **F21** — Feed-cost index (relative, base year = 100)
- **F22** — Registered Wagyu brands / certification marks (count)


**Series invariants:** 19 core + 3 extension = **22** points; coordinate `(country, year)`, `year ∈ [2002, 2026]`; codes fixed; extension append-only.

## 3. Legend

| Symbol | Meaning |
|---|---|
| `value [Src]` | Reported value from `wagyu.data.csv` with its source tag |
| `NR*` | Not reported (no value supplied in the CSV for this cell) |
| `producer` / `importer` / `no-data` | documented breeding-or-production / export-destination / none found |

## 4. Population status

- Intrinsic series: **22** points × **25** years × **195** countries = **107,250** cells.
- Cells populated from `wagyu.data.csv`: **14**.
- Remaining `NR*`: **107,236**.

Sourcing for the seeded values (Japan, Australia, United States) is in the CSV
`source` column and expanded in `wagyu/README.md` §Sources. Fetches of primary
sites were blocked in the authoring environment (HTTP 403); seeded figures came
from indexed search results and are cited.

## 5. Per-country register (alphabetical) — full intrinsic series × 25 years

Reported cells carry a source tag; every other cell is `NR*`.


### Afghanistan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Albania

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Algeria

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Andorra

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Angola

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Antigua and Barbuda

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Argentina

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Armenia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Australia

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.  |  Contains reported values (tagged cells).

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | 104,222 registered dams [S18] | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | >25,000 (per year, recent) [S9] | >40,000 (per year) [S19] | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | ~AUD 2000m boxed (~US$1330m*) [S4] | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | 12,224 sires [S18] | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | ~1,200 members (450 intl) [S5] | >1,500 members (650 intl); DB >400,000 [S20] | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Austria

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Azerbaijan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bahamas

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bahrain

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bangladesh

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Barbados

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Belarus

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Belgium

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Belize

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Benin

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bhutan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bolivia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bosnia and Herzegovina

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Botswana

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Brazil

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Brunei

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Bulgaria

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Burkina Faso

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Burundi

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Cabo Verde

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Cambodia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Cameroon

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Canada

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Central African Republic

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Chad

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Chile

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### China

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Colombia

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Comoros

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Congo (Brazzaville)

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Congo (Kinshasa)

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Costa Rica

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Croatia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Cuba

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Cyprus

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Czechia

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Denmark

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Djibouti

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Dominica

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Dominican Republic

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ecuador

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Egypt

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### El Salvador

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Equatorial Guinea

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Eritrea

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Estonia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Eswatini

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ethiopia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Fiji

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Finland

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### France

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Gabon

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Gambia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Georgia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Germany

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ghana

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Greece

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Grenada

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Guatemala

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Guinea

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Guinea-Bissau

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Guyana

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Haiti

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Honduras

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Hungary

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Iceland

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### India

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Indonesia

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Iran

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Iraq

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ireland

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Israel

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Italy

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ivory Coast

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Jamaica

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Japan

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.  |  Contains reported values (tagged cells).

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | 1,368,800 [S14] | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | >90% Japanese Black [S15] | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | IMF >30% (longissimus) [S16] | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | 10,826 (all beef, mostly Wagyu) [S3] | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | ~¥64.8bn (~US$430m*) [S7b] | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Jordan

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Kazakhstan

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Kenya

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Kiribati

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Kuwait

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Kyrgyzstan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Laos

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Latvia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Lebanon

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Lesotho

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Liberia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Libya

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Liechtenstein

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Lithuania

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Luxembourg

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Madagascar

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Malawi

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Malaysia

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Maldives

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mali

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Malta

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Marshall Islands

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mauritania

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mauritius

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mexico

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Micronesia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Moldova

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Monaco

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mongolia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Montenegro

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Morocco

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Mozambique

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Myanmar

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Namibia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Nauru

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Nepal

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Netherlands

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### New Zealand

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Nicaragua

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Niger

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Nigeria

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### North Korea

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### North Macedonia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Norway

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Oman

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Pakistan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Palau

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Panama

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Papua New Guinea

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Paraguay

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Peru

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Philippines

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Poland

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Portugal

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Qatar

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Romania

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Russia

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Rwanda

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Saint Kitts and Nevis

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Saint Lucia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Saint Vincent and the Grenadines

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Samoa

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### San Marino

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Sao Tome and Principe

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Saudi Arabia

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Senegal

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Serbia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Seychelles

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Sierra Leone

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Singapore

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Slovakia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Slovenia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Solomon Islands

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Somalia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### South Africa

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### South Korea

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### South Sudan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Spain

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Sri Lanka

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Sudan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Suriname

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Sweden

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Switzerland

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Syria

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Taiwan

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Tajikistan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Tanzania

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Thailand

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Timor-Leste

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Togo

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Tonga

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Trinidad and Tobago

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Tunisia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Turkey

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Turkmenistan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Tuvalu

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Uganda

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Ukraine

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### United Arab Emirates

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### United Kingdom

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### United States

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.  |  Contains reported values (tagged cells).

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | <5000 Fullblood (est.) [S22] | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | >900 AWA members [S23] | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Uruguay

- **Tier:** `producer`  |  **Status:** Documented Wagyu breeding herd / production.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Uzbekistan

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Vanuatu

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Vatican City

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Venezuela

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Vietnam

- **Tier:** `importer`  |  **Status:** Documented Wagyu *export destination* market.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Yemen

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Zambia

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

### Zimbabwe

- **Tier:** `no-data`  |  **Status:** No Wagyu-specific activity found in the checked sources; all fields Not Reported.

| Field / Year | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F01 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F02 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F03 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F04 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F05 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F06 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F07 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F08 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F09 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F10 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F11 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F12 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F13 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F14 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F15 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F16 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F17 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F18 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F19 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F20 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F21 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |
| F22 | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* | NR* |

---

*Generated from `wagyu.data.csv` by `build_wagyu.py`. The Wagyu Intrinsic Series (§2) is canonical: 19 core + 3 extension = 22 points over 2002–2026. Populate by editing the CSV and regenerating; never hand-edit values here.*
