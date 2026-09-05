# WAGYU.MASTER.md — Master Data Register for Wagyu (the product)

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Master data register — DEFINITIONS COMPLETE, VALUES PARTIAL (sourced where reported; otherwise Not Reported)

---

## 0. Data-integrity contract (read first)

This document is a **master data register**. It is governed by one rule:

> **No value in this register is invented and then presented as measured fact.**

- Cells with a real, published figure are written plainly and carry a **source tag** `[Sn]` (see §6, Sources).
- Cells with **no reported Wagyu-specific value** are written `NR*` — *Not Reported*.
- Where a country has documented Wagyu activity but no per-figure data, the country's
  summary line may give a **qualitative modelled estimate**, always marked with an
  asterisk `*` and explained in the **estimate-basis footnote** (§5). An estimate is
  never written into a numeric field as if it were observed.

Why so much is `NR*`: "Wagyu" is a specific set of Japanese cattle breeds (Japanese
Black, Japanese Brown/Akaushi, Japanese Shorthorn, Japanese Polled) and their
graded descendants abroad — **not** a customs commodity code. National statistics
agencies, FAOSTAT, and UN Comtrade record *beef*, not *Wagyu*, so a fully populated
195-country × 25-year × 19-field Wagyu matrix **does not exist in any public source**.
Rather than fabricate ~92,000 numbers, this register captures what is genuinely
reported and honestly flags the rest. See §4 for what is actually known.

## 1. The economic unit of Wagyu (the product)

The **economic unit** for this register is:

> **one kilogram of graded Wagyu carcass-weight beef (kg cwt)**, produced from cattle
> registered/graded as Wagyu (fullblood, purebred, or graded crossbred per the
> relevant national herdbook), valued in **US dollars** at the wholesale/boxed-beef
> point of sale.

Head-based and herd-based fields are recorded alongside because the carcass unit is
derived from them. Currency is normalised to USD; where a source reports AUD/JPY the
original is preserved in the source note.

## 2. The 19 data points (schema)

Each country-year record carries these fields:


- **F01** — Registered Wagyu / Wagyu-influenced cattle (head)
- **F02** — Fullblood/purebred share of registered herd (%)
- **F03** — Wagyu females of breeding age (head)
- **F04** — Calves registered in year (head)
- **F05** — Head slaughtered / turned off for Wagyu beef (head)
- **F06** — Carcass production (tonnes cwt)
- **F07** — Average carcass weight (kg cwt)
- **F08** — Average marbling score (AUS-MEAT / BMS scale)
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
- **F19** — Number of registered Wagyu breeders / seedstock members


## 3. Coverage legend

| Symbol | Meaning |
|---|---|
| `123 [S1]` | Reported value with source tag |
| `NR*` | Not reported for this country-year (no Wagyu-specific figure published) |
| `*` | Value/summary is a modelled estimate — see §5 estimate basis |
| `producer` | Country with a documented Wagyu breeding herd / production |
| `importer` | Country documented as a Wagyu export destination market |
| `no-data` | No Wagyu-specific activity found in the cited sources |

## 4. What is actually reported (global anchor facts, sourced)

These are the real, citable figures. All per-country estimates in §7 are anchored to them.

- **Global herd distribution:** ~**96%** of Wagyu cattle are in **Japan**; the second-largest population is in **Australia**. [S7]
- **Japan — exports (all beef, overwhelmingly Wagyu):** 2024 was a record year at about **¥64.8 billion** and roughly **10,000+ tonnes**; leading destinations are the **United States, Taiwan, and Hong Kong**. [S2][S3] Japan's Wagyu/beef is exported to ~**45 countries**. [S1]
- **Australia — largest Wagyu *exporter* in the world:** estimated **boxed production value AUD ~2.0 billion (2023)**, with ~**80%** exported to **40+ countries**. [S4] The Australian Wagyu Association adds **~25,000 calves/year** to its database; membership ~**1,200** (450 international). [S9][S5]
- **Foundation genetics:** **221** Wagyu cattle exported from Japan (1976 & early 1990s) formed the basis of all Wagyu/Akaushi herds in the **USA, Canada and Australia**. [S8][S10]
- **United States:** herds built from the original 1976/1993 imports; American "purebred" = 15/16 (93.75%) Wagyu. [S10]
- **Other documented breeding herds:** Canada, New Zealand, and multiple European countries (Netherlands, UK, Ireland, Germany, France, Spain, Italy, Denmark, Sweden, etc.) via De Drie Morgen / Takeda Farms bloodlines. [S8][S11]
- **Market-size context (aggregate, forecaster estimates — note sources disagree):** global Wagyu beef market variously put at **USD ~13.6–26.9 billion (2025)**. [S12][S13] These are third-party market models, not measured trade data, and are recorded here as context only.

## 5. Estimate-basis footnote (applies to every `*`)

Where a country is a documented `producer` or `importer` but no per-year/per-field
figure is published, the summary estimate is derived **only** by apportioning the
§4 anchor totals using publicly-known qualitative shares (e.g. Australia ≈ largest
exporter; US/Taiwan/Hong Kong ≈ largest Japanese-export destinations). These are
**order-of-magnitude modelled inferences, not observations**, and must not be cited
as national statistics. Any `no-data` country is left fully `NR*`: absence of a
Wagyu figure is reported as absence, never estimated up from zero.

## 6. Sources

- **[S1]** MAFF (Japan), export company profile — beef exported to 45 countries. maff.go.jp
- **[S2]** Nippon.com — Japan beef exports record high; US/Taiwan/Hong Kong lead (2025). nippon.com
- **[S3]** Japanese industry export ranking — 2024 ≈ ¥64.8bn, ~10,000-tonne class. rakusurukurasi.com
- **[S4]** Australian Wagyu Association — largest exporter; AUD ~2.0bn boxed value 2023; ~80% to 40+ countries. wagyu.org.au
- **[S5]** AWA International Wagyu Office Fact Sheet — ~1,200 members (450 international). wagyu.org.au
- **[S7]** Wagyu International — ~96% of Wagyu in Japan; Australia second. wagyuinternational.co
- **[S8]** Wagyu International (foundation) — 221 foundation cattle → USA/Canada/Australia. wagyuinternational.co
- **[S9]** Australian Wagyu Association (about) — ~25,000 calves added per year. wagyu.org.au
- **[S10]** Wagyu International (USA) — US herd origins; 15/16 purebred definition. wagyuinternational.co
- **[S11]** Wagyu International (Netherlands) — European herds from De Drie Morgen / Takeda bloodlines. wagyuinternational.co
- **[S12]** Fortune Business Insights — global Wagyu market USD ~26.9bn (2025). fortunebusinessinsights.com
- **[S13]** Straits Research / Mordor Intelligence — global Wagyu market USD ~13.6–13.9bn (2025). straitsresearch.com / mordorintelligence.com

*Content from the above sources was rephrased/summarised for compliance with licensing restrictions.*

## 7. Per-country register (alphabetical)

Each country shows: tier, a one-line status (with `*` if modelled), and the
25-year × 19-field grid. Reported cells carry a source tag; all others are `NR*`.


### Afghanistan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Albania

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Algeria

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Andorra

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Angola

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Antigua and Barbuda

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Argentina

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Armenia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Australia

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*

- **Anchored facts:** world's largest Wagyu exporter; boxed value AUD ~2.0bn (2023), ~80% exported to 40+ countries [S4]; ~25,000 calves/yr registered [S9].


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

### Austria

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Azerbaijan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bahamas

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bahrain

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Bangladesh

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Barbados

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Belarus

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Belgium

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Belize

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Benin

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bhutan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bolivia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bosnia and Herzegovina

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Botswana

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Brazil

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Brunei

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Bulgaria

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Burkina Faso

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Burundi

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Cabo Verde

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Cambodia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Cameroon

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Canada

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*

- **Anchored facts:** foundation Wagyu/Akaushi herd from Japanese genetics [S8].


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

### Central African Republic

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Chad

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Chile

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### China

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Colombia

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Comoros

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Congo (Brazzaville)

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Congo (Kinshasa)

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Costa Rica

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Croatia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Cuba

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Cyprus

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Czechia

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Denmark

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Djibouti

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Dominica

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Dominican Republic

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Ecuador

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Egypt

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### El Salvador

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Equatorial Guinea

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Eritrea

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Estonia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Eswatini

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Ethiopia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Fiji

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Finland

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### France

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Gabon

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Gambia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Georgia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Germany

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Ghana

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Greece

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Grenada

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Guatemala

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Guinea

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Guinea-Bissau

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Guyana

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Haiti

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Honduras

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Hungary

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Iceland

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### India

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Indonesia

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Iran

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Iraq

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Ireland

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Israel

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Italy

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Ivory Coast

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Jamaica

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Japan

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*

- **Anchored facts:** ~96% of world Wagyu herd [S7]; 2024 beef exports ≈ ¥64.8bn / ~10,000t class, top destinations US/Taiwan/Hong Kong [S2][S3]; exports to ~45 countries [S1].


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

### Jordan

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Kazakhstan

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Kenya

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Kiribati

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Kuwait

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Kyrgyzstan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Laos

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Latvia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Lebanon

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Lesotho

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Liberia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Libya

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Liechtenstein

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Lithuania

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Luxembourg

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Madagascar

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Malawi

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Malaysia

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Maldives

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Mali

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Malta

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Marshall Islands

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Mauritania

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Mauritius

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Mexico

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Micronesia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Moldova

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Monaco

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Mongolia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Montenegro

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Morocco

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Mozambique

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Myanmar

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Namibia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Nauru

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Nepal

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Netherlands

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### New Zealand

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Nicaragua

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Niger

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Nigeria

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### North Korea

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### North Macedonia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Norway

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Oman

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Pakistan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Palau

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Panama

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Papua New Guinea

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Paraguay

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Peru

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Philippines

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Poland

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Portugal

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Qatar

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Romania

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Russia

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Rwanda

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Saint Kitts and Nevis

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Saint Lucia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Saint Vincent and the Grenadines

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Samoa

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### San Marino

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Sao Tome and Principe

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Saudi Arabia

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Senegal

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Serbia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Seychelles

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Sierra Leone

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Singapore

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Slovakia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Slovenia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Solomon Islands

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Somalia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### South Africa

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### South Korea

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### South Sudan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Spain

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Sri Lanka

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Sudan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Suriname

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Sweden

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Switzerland

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Syria

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Taiwan

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*

- **Anchored facts:** among the largest destination markets for Japanese Wagyu exports [S2].


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

### Tajikistan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Tanzania

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Thailand

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Timor-Leste

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Togo

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Tonga

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Trinidad and Tobago

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Tunisia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Turkey

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Turkmenistan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Tuvalu

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Uganda

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Ukraine

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### United Arab Emirates

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### United Kingdom

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### United States

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*

- **Anchored facts:** foundation herd from 1976/1993 Japanese imports; 15/16 = purebred [S8][S10]; a leading destination for Japanese Wagyu exports [S2].


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

### Uruguay

- **Tier:** `producer`

- **Status:** Documented Wagyu breeding herd and/or production. Per-year, per-field national Wagyu figures are not published; summary is a modelled estimate.*


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

### Uzbekistan

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Vanuatu

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Vatican City

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Venezuela

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Vietnam

- **Tier:** `importer`

- **Status:** Documented Wagyu *export destination* market. No per-year Wagyu-specific import figures are published; summary is a modelled estimate.*


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

### Yemen

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Zambia

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

### Zimbabwe

- **Tier:** `no-data`

- **Status:** No Wagyu-specific breeding, production, or trade activity found in the cited sources. All fields Not Reported.


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

---

*End of register. Definitions (§1–§2) and sources (§6) are authoritative; numeric cells are `NR*` pending a real data feed (FAOSTAT/Comtrade beef proxies + national herdbook exports). Populate via a reviewed data pipeline, not by hand.*
