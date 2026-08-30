# Korea Economic & Supply Evaluation

> **Model status:** source-aware research prototype. Facts and assumptions are deliberately separated.

## Executive view

| Measure | Observation | Treatment |
|---|---:|---|
| Korea nominal GDP, 2025 | $1.872T | factual |
| Hanwoo 1st-grade rib, 2022 | ₩7,850 / 100g | factual historical retail observation |
| Hanwoo 1st-grade rib, 2021 | ₩6,857 / 100g | factual historical retail observation |
| Hanwoo 1st-grade sirloin, 2026 snapshot | ₩10,137 / 100g | current KAMIS/MFRA observation |
| Hanwoo herd | 337 → 321 → 315k?* | factual/projection series |
| U.S. adult male mean height | 68.9 in / ~175.0 cm | factual population reference |
| U.S. adult female mean height | 63.5 in / ~161.3 cm | factual population reference |
| Oldest active football record | 74 years 125 days | factual Guinness record |
| Lifetime water baseline | 1,000,000 L | explicit model assumption |

\* Herd figures are reported in ten-thousand-head units: 337 (2024), 321 (2025), 315 projected low (2026), 321 projected (2028).

## Hanwoo price and quality

KAMIS reports 1st-grade Hanwoo rib at ₩6,857/100g in 2021 and ₩7,850/100g in 2022 in its historical annual retail series. Current KAMIS/MFRA material reports a 2026 1st-grade sirloin retail observation of ₩10,137/100g. These are **not treated as one uninterrupted product series** because the cut and reporting periods differ.

For computation, the project uses an **ordinal quality score** rather than claiming an official numeric quality index:

| Grade | Model score |
|---|---:|
| 1+ | 100 |
| 1 | 90 |
| 2 | 75 |
| 3 | 60 |

This score is a modeling convenience, not an official Korean quality measurement.

## Supply lines

The Ministry of Agriculture reports declining Hanwoo herd size from 337 ten-thousand head in 2024 to 321 in 2025, with a projected low of 315 in 2026 and 321 in 2028. It also reports a 2026 Q1-mid wholesale price observation of ₩22,036/kg for the specified steer category. citeturn0search6

Feed is represented as a separate supply-line variable because the Ministry publishes monthly compound-feed production and price statistics. The dataset therefore leaves room for later ingestion of the published spreadsheets rather than inventing feed-price values. citeturn0search1turn0search2

## American stature

CDC/NCHS reports measured mean adult height of 68.9 inches for U.S. men and 63.5 inches for U.S. women, ages 20 and older, from August 2021–August 2023 data. citeturn1search13

These values are used only as population references. They do not imply a value judgment about people.

## Long-life football reference

Guinness World Records identifies Ezzeldin Bahader as the oldest active male football/soccer player at **74 years and 125 days**, verified in Cairo on March 7, 2020. FIFA likewise describes him as the oldest professional footballer to play an official game. citeturn1search0turn1search6

No combined-wealth number is assigned to Bahader without a reliable public source. Likewise, “lifetime giftedness” is retained only as a **model variable**, never as a factual claim about his intelligence or worth.

## Water over a lifetime

The first model uses 1,000,000 liters as a neutral lifetime-use baseline and initializes modeled use at the same value, giving an index of 1.000. This is intentionally an assumption so later household, municipal, agricultural, or industrial water-use datasets can replace it.

## Consumer viewpoint

The project uses **consumer price pressure** rather than “American greed” as a computed category. Price burden can be evaluated; a moral characterization of consumers cannot be inferred from the price data.

## Four-property congruence model

Each item receives four related line properties:

| Property | Meaning |
|---|---|
| Sign | Positive, negative, or neutral relationship |
| Tenor | Short, medium, long, annual, age, or record horizon |
| Length | Normalized relation magnitude from 0 to 1 |
| Relation | Price, supply, quality, burden, resilience, or use |

The complete machine-readable relations are in `congruences.xml`. The evaluated output is in `results.xml`.

## Sources

- KAMIS historical livestock retail prices. citeturn0search3
- Ministry of Agriculture, Food and Rural Affairs Hanwoo supply/price outlook. citeturn0search6
- Ministry compound-feed production and price statistics. citeturn0search1
- World Bank World Development Indicators, Korea GDP. citeturn1search9
- CDC/NCHS U.S. adult body measurements. citeturn1search13
- Guinness World Records, oldest active football player. citeturn1search0
