#!/usr/bin/env python3
"""build_wagyu.py — rebuild wagyu/WAGYU.MASTER.md from wagyu/wagyu.data.csv.

The CSV is the single source of truth for VALUES. This script owns the schema
(the Wagyu Intrinsic Series), the country list, the years, and the prose; it
merges in whatever values the CSV supplies and writes every other cell as NR*.

Workflow:
    1. Edit wagyu/wagyu.data.csv  (fill `value` and `source` for cells you have).
    2. Run:  python3 wagyu/build_wagyu.py
    3. Commit both the CSV and the regenerated WAGYU.MASTER.md.

Integrity rule: only rows present in the CSV with a non-empty `value` become
written cells; everything else is NR*. Nothing is invented by this script.

CSV columns (header required):
    country,year,field,value,source
      country  exact name from the canonical list (see COUNTRIES)
      year     integer 2002..2026
      field    F01..F22 (the intrinsic series code)
      value    the reported figure as it should appear in the cell (may be blank)
      source   short source tag/citation, e.g. "S14" or "AWA 2023"; blank ok
Rows with blank `value` are ignored (treated as NR*). Unknown country/field/year
values are reported as errors so typos never silently vanish.
"""

import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(HERE, "wagyu.data.csv")
OUT_PATH = os.path.join(HERE, "WAGYU.MASTER.md")

YEARS = list(range(2002, 2027))

CORE = [
    ("F01", "Registered Wagyu / Wagyu-influenced cattle (head)"),
    ("F02", "Fullblood/purebred share of registered herd (%)"),
    ("F03", "Wagyu females of breeding age / registered dams (head)"),
    ("F04", "Calves registered in year (head)"),
    ("F05", "Head slaughtered / turned off for Wagyu beef (head)"),
    ("F06", "Carcass production (tonnes cwt)"),
    ("F07", "Average carcass weight (kg cwt)"),
    ("F08", "Average marbling / intramuscular fat"),
    ("F09", "Farmgate price (USD/head)"),
    ("F10", "Wholesale carcass price (USD/kg cwt)"),
    ("F11", "Retail premium vs commodity beef (x multiple)"),
    ("F12", "Boxed-beef production value (USD million)"),
    ("F13", "Export volume (tonnes)"),
    ("F14", "Export value (USD million)"),
    ("F15", "Average export unit price (USD/kg)"),
    ("F16", "Import volume (tonnes)"),
    ("F17", "Import value (USD million)"),
    ("F18", "Domestic Wagyu consumption (tonnes)"),
    ("F19", "Registered Wagyu breeders / seedstock members / DB individuals"),
]
EXT = [
    ("F20", "Herd growth rate, year-on-year (%)"),
    ("F21", "Feed-cost index (relative, base year = 100)"),
    ("F22", "Registered Wagyu brands / certification marks (count)"),
]
FIELDS = CORE + EXT
FIELD_CODES = [c for c, _ in FIELDS]

COUNTRIES = [
 "Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria",
 "Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan",
 "Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cabo Verde","Cambodia",
 "Cameroon","Canada","Central African Republic","Chad","Chile","China","Colombia","Comoros","Congo (Brazzaville)","Congo (Kinshasa)",
 "Costa Rica","Croatia","Cuba","Cyprus","Czechia","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador",
 "Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Eswatini","Ethiopia","Fiji","Finland","France",
 "Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau",
 "Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland",
 "Israel","Italy","Ivory Coast","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait",
 "Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg",
 "Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico",
 "Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nauru",
 "Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","North Macedonia","Norway","Oman",
 "Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar",
 "Romania","Russia","Rwanda","Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia",
 "Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa",
 "South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Sweden","Switzerland","Syria","Taiwan",
 "Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan",
 "Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vanuatu","Vatican City",
 "Venezuela","Vietnam","Yemen","Zambia","Zimbabwe",
]
COUNTRY_SET = set(COUNTRIES)

PRODUCERS = {
 "Japan","Australia","United States","Canada","New Zealand","United Kingdom","Ireland","Netherlands",
 "Germany","France","Spain","Italy","Denmark","Sweden","Belgium","Switzerland","Austria","Chile",
 "Argentina","Brazil","South Africa","China","Mexico","Uruguay","Czechia","Poland","Norway","Finland","Portugal","Hungary",
}
KNOWN_IMPORTERS = {
 "United States","Taiwan","Hong Kong","Singapore","Thailand","South Korea","United Arab Emirates","Qatar",
 "Saudi Arabia","Kuwait","Bahrain","Malaysia","Philippines","Indonesia","Vietnam","India","Israel",
 "Switzerland","Monaco","Luxembourg","Iceland","Russia","Turkey","Mexico","Brazil","Canada","New Zealand",
 "United Kingdom","France","Germany","Italy","Spain","Netherlands","Belgium","Austria","Denmark","Sweden",
 "Norway","Finland","Ireland","Portugal","Greece","Cyprus","Malta","Panama","Chile","Colombia","Peru",
 "Argentina","Uruguay","South Africa","Mauritius","Maldives","Fiji","Egypt","Jordan","Lebanon","Oman","Kazakhstan",
}
def tier(c):
    if c in PRODUCERS: return "producer"
    if c in KNOWN_IMPORTERS: return "importer"
    return "no-data"

def load_csv():
    """Return {(country, year, field): cell_text} and a list of errors."""
    values = {}
    errors = []
    if not os.path.exists(CSV_PATH):
        errors.append(f"CSV not found: {CSV_PATH}")
        return values, errors
    with open(CSV_PATH, newline="", encoding="utf-8") as fh:
        # Drop comment (#...) and blank lines before CSV parsing; keep the header.
        lines = [ln for ln in fh if ln.strip() and not ln.lstrip().startswith("#")]
        reader = csv.DictReader(lines)
        need = {"country", "year", "field", "value", "source"}
        if not need.issubset(set(reader.fieldnames or [])):
            errors.append(f"CSV header must contain {sorted(need)}; got {reader.fieldnames}")
            return values, errors
        for i, row in enumerate(reader, start=2):
            val = (row.get("value") or "").strip()
            if not val:
                continue  # blank value => NR*, skip
            country = (row.get("country") or "").strip()
            field = (row.get("field") or "").strip().upper()
            ystr = (row.get("year") or "").strip()
            src = (row.get("source") or "").strip()
            if country not in COUNTRY_SET:
                errors.append(f"line {i}: unknown country '{country}'")
                continue
            if field not in FIELD_CODES:
                errors.append(f"line {i}: unknown field '{field}'")
                continue
            try:
                year = int(ystr)
            except ValueError:
                errors.append(f"line {i}: bad year '{ystr}'")
                continue
            if year not in YEARS:
                errors.append(f"line {i}: year {year} out of range 2002-2026")
                continue
            cell = val if not src else f"{val} [{src}]" if not val.rstrip().endswith("]") else val
            values[(country, year, field)] = cell
    return values, errors

HEADER = """# WAGYU.MASTER.md — Master Data Register for Wagyu (the product)

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

"""

def build(values):
    out = [HEADER]
    for code, label in CORE:
        out.append(f"- **{code}** — {label}")
    out.append("\n**Extension block — E-series (the \"+\"; reserved & appended):**\n")
    for code, label in EXT:
        out.append(f"- **{code}** — {label}")
    filled = len(values)
    out.append(f"""

**Series invariants:** {len(CORE)} core + {len(EXT)} extension = **{len(FIELDS)}** points; coordinate `(country, year)`, `year ∈ [2002, 2026]`; codes fixed; extension append-only.

## 3. Legend

| Symbol | Meaning |
|---|---|
| `value [Src]` | Reported value from `wagyu.data.csv` with its source tag |
| `NR*` | Not reported (no value supplied in the CSV for this cell) |
| `producer` / `importer` / `no-data` | documented breeding-or-production / export-destination / none found |

## 4. Population status

- Intrinsic series: **{len(FIELDS)}** points × **{len(YEARS)}** years × **{len(COUNTRIES)}** countries = **{len(FIELDS)*len(YEARS)*len(COUNTRIES):,}** cells.
- Cells populated from `wagyu.data.csv`: **{filled:,}**.
- Remaining `NR*`: **{len(FIELDS)*len(YEARS)*len(COUNTRIES) - filled:,}**.

Sourcing for the seeded values (Japan, Australia, United States) is in the CSV
`source` column and expanded in `wagyu/README.md` §Sources. Fetches of primary
sites were blocked in the authoring environment (HTTP 403); seeded figures came
from indexed search results and are cited.

## 5. Per-country register (alphabetical) — full intrinsic series × 25 years

Reported cells carry a source tag; every other cell is `NR*`.

""")
    note = {
     "producer": "Documented Wagyu breeding herd / production.",
     "importer": "Documented Wagyu *export destination* market.",
     "no-data": "No Wagyu-specific activity found in the checked sources; all fields Not Reported.",
    }
    for name in COUNTRIES:
        t = tier(name)
        has = any((name, y, c) in values for c in FIELD_CODES for y in YEARS)
        out.append(f"### {name}\n")
        out.append(f"- **Tier:** `{t}`  |  **Status:** {note[t]}" + ("  |  Contains reported values (tagged cells)." if has else "") + "\n")
        out.append("| Field / Year | " + " | ".join(str(y) for y in YEARS) + " |")
        out.append("|" + "---|" * (len(YEARS) + 1))
        for code, _label in FIELDS:
            cells = [code]
            for y in YEARS:
                cells.append(values.get((name, y, code), "NR*"))
            out.append("| " + " | ".join(cells) + " |")
        out.append("")
    out.append(f"---\n\n*Generated from `wagyu.data.csv` by `build_wagyu.py`. The Wagyu Intrinsic Series (§2) is canonical: {len(CORE)} core + {len(EXT)} extension = {len(FIELDS)} points over 2002–2026. Populate by editing the CSV and regenerating; never hand-edit values here.*\n")
    return "\n".join(out)

def main():
    values, errors = load_csv()
    if errors:
        sys.stderr.write("CSV issues:\n" + "\n".join(f"  - {e}" for e in errors) + "\n")
        # Unknown-country/field/year are fatal (typos); missing-CSV is fatal too.
        if any(("unknown" in e or "bad year" in e or "out of range" in e or "not found" in e or "header" in e) for e in errors):
            sys.exit(1)
    with open(OUT_PATH, "w", encoding="utf-8") as fh:
        fh.write(build(values))
    print(f"wrote {OUT_PATH}: {len(values)} value cells populated, "
          f"{len(FIELDS)*len(YEARS)*len(COUNTRIES)-len(values)} NR*.")

if __name__ == "__main__":
    main()
