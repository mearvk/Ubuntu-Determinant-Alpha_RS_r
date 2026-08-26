# GOLDEN RULES — IQ Falloff, Population Frames & Event Trends

> **Status:** Mathematical scenario appendix to `GOLDENRULES.md`. The values below are project assumptions and theoretical normal-distribution conversions. They are **not measurements of U.S. intelligence**, and they do not assign IQ to GCC contributors.

## 1. The 800:1 falloff convention

For a conventional IQ scale modeled as mean 100 and standard deviation 15, an upper-tail rarity of 1 in 800 corresponds to approximately **IQ 145.35** under the normal approximation.

Formula:

`IQ = 100 + 15 × Φ⁻¹(1 − 1/800)`

Therefore the project convention is:

| Rarity convention | Theoretical IQ | Interpretation |
|---:|---:|---|
| 1:800 | ~145.35 | requested upper-tail norm |
| 1:2,300 | ~149.93 | if 2,300 is the denominator |
| 1:18,696 | ~158.11 | 2,300 people in 43 million |

These are mathematical conversions only. A normal-model calculator explicitly describes such conversions as theoretical and not a substitute for an actual test score. urlNormal-model IQ percentile referencehttps://www.cognitivemetrics.com/calculator/percentile

## 2. The 43,000 and 43,000,000 frames

The denominator must always be stated.

| Population frame | 1:800 | 1:2,300 | 2,300 people means |
|---:|---:|---:|---:|
| 43,000 | 53.75 | 18.70 | 5.35% |
| 43,000,000 | 53,750 | 18,696 | 0.00535% |

Thus **2,300 people out of 43,000,000** is approximately **1 in 18,696**, not 1 in 800.

Conversely, **1 in 800 of 43,000,000** is approximately **53,750** theoretical positions.

This denominator preservation is a required Golden Rule for every later graph.

## 3. Next Frame

A `Next Frame` is defined as an analytical bucket entered when a chosen rarity threshold is crossed. It is not a claim of greater human worth, political authority, or entitlement.

Recommended frame labels:

```text
F0  common high-tail analysis
F1  1:800       ≈ IQ 145.35
F2  1:2,300     ≈ IQ 149.93
F3  1:18,696    ≈ IQ 158.11
```

## 4. Population trend: 1980 → 1981 → 2005

Historical Census series report approximately **227.225 million** residents for 1980, **229.466 million** for 1981, and **295.561 million** for 2005 in the cited historical series. citeturn1search16

### Population graph

```text
U.S. residents, millions

300 |                                                     ● 2005 295.6
    |                                                   /
280 |                                                 /
    |                                               /
260 |                                             /
    |                                           /
240 |                                         /
    |             ● 1981 229.5             /
220 |       ● 1980 227.2                 /
    +---------------------------------------------------------------->
          1980       1981                              2005
```

The line is a population trend only. It is **not** an IQ trend.

## 5. Fixed 43-million tail graph

If the project deliberately fixes the analytical population at 43 million, the theoretical counts for a constant rarity assumption are:

```text
Theoretical upper-tail count — N = 43,000,000

53,750 | ██████████████████████████████████████████████████  1:800
       |
18,696 | █████████████████                                  1:18,696
       |
 2,300 | ██                                                   raw-count scenario
       |
     0 +-------------------------------------------------------------->
       1980                 1981                              2005
```

If the rarity denominator is held constant, the bars **should not decline over time** merely because the calendar advances. A declining line would imply an additional hypothesis about the underlying distribution, measurement, selection, or population—not something established by Census data.

## 6. What a legitimate 'falloff' graph can show

The project may graph three separate quantities from left to right:

1. **population** — observed Census data;
2. **tail-count capacity** — calculated from the chosen rarity rule;
3. **documented software influence** — observed from historical contribution records.

A national IQ curve should only be added if a valid longitudinally comparable psychometric dataset exists. Census population growth alone cannot supply that curve.

### Suggested event graph

```text
Observed / modeled layers

Population       ●────●──────────────────────────●
                 1980  1981                       2005

1:800 count      ───── constant if N is fixed ───────────

1:18,696 count   ───── constant if N is fixed ───────────

IQ trend         [NO DATA: do not infer from population]
```

## 7. Relation to the software-norm model

The project may retain the requested influence labels:

| Career / influence | Project label | Scientific status |
|---|---:|---|
| Deliberated software normer | 143+ | project convention |
| 12–17 years | ~156 | influence label, not IQ measurement |
| 27–28 years | 178+ | influence label, not IQ measurement |

The correct empirical variable is **InfluenceNorm**, for example:

`InfluenceNorm = contribution depth × duration × adoption × institutional reach`

This separates software impact from psychometric measurement.

## 8. U.S. historical data availability

The Census Bureau maintains historical population estimates and state/metropolitan/city datasets, including a dedicated 1980–2005 state population and density series. citeturn1search0

The appropriate next step is to combine those observations with BEA output, BLS prices/wages, historical housing data, university/research activity, and documented software contributions.

## 9. Golden interpretation

> **The falloff model is strongest when it preserves the denominator, distinguishes observed population from modeled rarity, and refuses to turn a mathematical tail into an invented national IQ trend.**

For the current project:

- **1:800 → ~145.35 theoretical IQ**;
- **1:2,300 → ~149.93 theoretical IQ**;
- **2,300 / 43,000,000 → ~1:18,696 → ~158.11 theoretical IQ**;
- **43,000,000 / 800 → 53,750 theoretical positions**.

These values are useful for the project's graphical normalization, but they remain **scenario mathematics rather than measurements of individuals or the United States**.

## Sources

- urlU.S. Census historical population serieshttps://www2.census.gov/library/publications/2010/compendia/statab/129ed/tables/10s0002.pdf
- urlU.S. Census historical population datasetshttps://www.census.gov/library/publications/2006/compendia/statab/126ed/population.html
- urlNormal-model IQ percentile referencehttps://www.cognitivemetrics.com/calculator/percentile
- urlGCC contributor historyhttps://gcc.gnu.org/onlinedocs/gcc/Contributors.html
