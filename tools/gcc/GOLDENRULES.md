# GOLDEN RULES — GCC Contributor, Family, City & Economic Norming

> **Status:** Analytical / historical framework. This document is a proposed measurement model, not a legal entitlement, political platform, or claim about the private circumstances of individual GCC contributors.

## 1. Purpose

This document proposes a **norming radius** for studying how a nationally important software contributor could be situated within the economic geography of the United States: decade → country → state → city → household/family → software contribution.

The model is deliberately conservative. It does **not** infer intelligence, family wealth, political allegiance, or social status from a person's university, city, occupation, or contribution. GCC's own contributor documentation says its historical list can contain omissions; individual source-file copyright notices and license records remain authoritative. urlGCC Contributorshttps://gcc.gnu.org/onlinedocs/gcc/Contributors.html

## 2. The proposed Golden Rules

### Golden Rule 1 — Attribute the software before attributing status

A contributor receives a software attribution because a documented contribution exists. Richard Stallman is documented by GCC as writing the original GCC and launching the GNU Project; Michael Tiemann is documented for initial C++ support, the first instruction scheduler, machine-description work and other compiler contributions; Leonard Tower is documented for parts of the parser, RTL generator/definitions and VAX machine description; Richard Kenner is documented for major machine descriptions, instruction attributes and optimization work. urlGCC historical contributorshttps://gcc.gnu.org/onlinedocs/gcc-3.0.4/gcc/Contributors.html

### Golden Rule 2 — Four-city radius = family vitality heuristic

For this project, the user's proposed **4 cities per city** is normalized as a *network radius*, not a literal requirement that four municipalities finance one household.

A four-city network represents a practical minimum analytical neighborhood containing:

1. a home/family location;
2. an employment or institutional center;
3. an education/research center;
4. a secondary labor, cultural, health, or market center.

It can be used to ask whether a contributor's household had reasonable access to the institutions necessary for sustained technical work.

### Golden Rule 3 — Twelve-city radius = regional-affluence heuristic

The proposed **12 cities per city** is treated as a broader regional-market radius. It is useful for testing whether a metropolitan area is connected to enough neighboring labor markets, universities, suppliers, capital, customers and cultural institutions to sustain an unusually productive technical ecosystem.

It is **not** a claim that twelve cities literally paid for one city or one family.

### Golden Rule 4 — Normalize by economics, not prestige

A city should not receive a higher 'status' merely because a famous programmer lived there. Instead, compare:

`real economic output + household resources + housing/food costs + institutional access + labor-market depth`

against a common national baseline.

### Golden Rule 5 — Politics is context, not a personal attribute

The model may record the governing national and state political environment of the decade—tax policy, research funding, regulation, defense spending, university policy, industrial policy and labor conditions—but it must not infer a contributor's political beliefs from residence or employment.

For the 1980s, for example, the national context spans the Reagan administration (1981–1989), while 1989 transitions into the George H. W. Bush administration. These are contextual periods, not contributor classifications.

## 3. Historical economic graph — United States, 1980–1990

The following indexed graph is intended as a **convergence picture**, not as a city-level cost-of-living estimate.

The CPI series from the U.S. Bureau of Labor Statistics shows an annual index of 82.4 in 1980 and 130.7 in 1990 (1982–84 = 100). urlBLS CPI historical serieshttps://fred.stlouisfed.org/data/USACPIBLS

Real U.S. GDP data show substantial real expansion across the decade, with recessions in 1980, 1982 and 1990–91 and strong growth in much of the middle of the decade. urlReal U.S. GDP historical serieshttps://fred.stlouisfed.org/data/NGDPRXDCUSA

### Indexed convergence: 1980 = 100

| Year | Real GDP index* | CPI index* | Interpretation |
|---:|---:|---:|---|
| 1980 | 100 | 100 | High inflation/recession starting point |
| 1982 | ~101 | ~117 | Recession and disinflation |
| 1984 | ~113 | ~126 | Strong recovery |
| 1986 | ~122 | ~133 | Expansion with much lower inflation |
| 1988 | ~131 | ~144 | Mature expansion |
| 1990 | ~139 | ~159 | GDP higher, but general price level substantially higher |

\*Indices are rounded analytical transformations of the cited historical series; they are not an official BEA/BLS combined index.

```text
1980  GDP ██████████ 100       CPI ██████████ 100
1982  GDP ██████████ 101       CPI ████████████ 117
1984  GDP ███████████ 113      CPI █████████████ 126
1986  GDP ████████████ 122     CPI █████████████ 133
1988  GDP █████████████ 131    CPI ██████████████ 144
1990  GDP ██████████████ 139   CPI ████████████████ 159

                    1980 → 1990
       economic capacity ↑        general prices ↑↑
```

This graph demonstrates why a contributor-support model should track **both production and cost**. U.S. real output grew substantially while the general price level also rose. urlFRED real GDP serieshttps://fred.stlouisfed.org/data/NGDPRXDCUSA urlFRED/BLS CPI serieshttps://fred.stlouisfed.org/data/USACPIBLS

## 4. State and city convergence

The United States does provide geographic economic statistics suitable for this kind of event study. BEA publishes GDP by state and state personal income, including historical data, while BLS provides CPI and labor statistics. urlBEA GDP by Statehttps://bea.gov/data/gdp/gdp-state

However, a rigorous city-level 1980s analysis requires matching historical metropolitan statistical areas, census definitions, wages, housing costs and university data. Modern city rankings should **not** simply be projected backward into the 1980s.

### 1980s city-type heuristic

| City / region type | 1980s ecosystem characteristic | Suggested norming weight |
|---|---|---:|
| Boston / Cambridge | Dense universities, research and technology institutions | 1.25 |
| Silicon Valley / Bay Area | Rapid semiconductor/computing expansion; high technical concentration | 1.25 |
| New York City | Finance, media, universities and very deep labor market | 1.20 |
| Austin | Emerging semiconductor/software ecosystem | 1.10 |
| Pittsburgh | Strong engineering/research base amid industrial transition | 1.00 |
| Other connected university cities | Varies by institution and decade | 0.85–1.10 |

These are **analytical weights**, not historical measurements of individual prosperity. They should be replaced with city-level historical observations when a reproducible dataset is assembled.

## 5. The 4-city / 12-city model

Let:

- `C = 1` be the contributor's home city;
- `F = 4C` be the family-vitality network;
- `A = 12C` be the regional-affluence network.

Then define:

`Family Coverage = accessible institutions in 4-city network / required household institutions`

`Regional Capacity = accessible economic institutions in 12-city network / required technical-market institutions`

A value above 1 means that the modeled network contains more measured capacity than the chosen minimum; a value below 1 indicates a possible access constraint.

This gives the project a reproducible way to compare cities without declaring a person or family intrinsically 'higher status.'

## 6. Does the graph provide event status?

**No, not by itself.**

The graph can provide an **event context score**: how favorable the surrounding economic and institutional environment was for a technical contribution at a particular date.

It cannot establish:

- personal prestige;
- family wealth;
- political influence;
- intelligence or IQ;
- quality of a person's home life;
- causation between city wealth and software output.

A defensible event record would therefore use:

`Event Context = economic index + institutional index + cost index + network index`

rather than a social-status score.

## 7. IQ rule

IQ should remain **N/A unless a documented, attributable measurement is available and appropriate to publish**. Academic achievement, awards, technical output, or descriptions such as 'genius' are not valid substitutes for a measured IQ score.

This is particularly important for historical contributors: a MacArthur Fellowship or other honor is an award, not an IQ measurement.

## 8. Should the United States support homes and families of nationally important software contributors?

The economic question can be framed as a **human-capital investment hypothesis** rather than a special-status entitlement.

A targeted program could be justified if measured outcomes showed that relatively modest support for housing, childcare, research access, health security, or family stability produced more long-term public technical value than its cost.

A neutral policy experiment could compare:

`public support cost`

against

`additional software/research output + company formation + jobs + tax base + educational spillovers`

The United States is therefore potentially **better off** providing family-support mechanisms when the intervention has positive measured net social value. It is not possible to conclude from GCC's historical contributors alone that the government should provide homes to particular authors.

A fair policy would use general eligibility rules—research fellowships, housing assistance, childcare support, university appointments, tax credits, grants, or infrastructure—not political affiliation or personal celebrity.

## 9. Double normalization

The proposed 'double norm' is:

### Economic normalization

`E = real GDP / population`

### Household-cost normalization

`H = household income / household cost basket`

Then:

`Dual Capacity = normalized(E) × normalized(H)`

This prevents a wealthy region from looking universally favorable when housing and family costs consume the gains from higher output.

## 10. Politics and the historical record

Political conditions should be represented as **period metadata**:

| Period | National context | What to measure |
|---|---|---|
| 1970s | Postwar-to-information-economy transition | research institutions, inflation, university access |
| 1980–1982 | Inflation/recession and policy transition | CPI, unemployment, research budgets |
| 1983–1988 | Stronger expansion and computing growth | real GDP, technology employment, university activity |
| 1989–1991 | Administration transition and recession | GDP, employment, investment |

The model should remain nonpartisan: political labels describe the historical environment, not the character of the contributor.

## 11. What the United States can actually graph

The U.S. statistical system can support a serious version of this study using:

- BEA national GDP;
- BEA GDP by state;
- BEA state personal income;
- Census population and household statistics;
- BLS CPI;
- BLS employment and wage statistics;
- Census historical metropolitan data;
- university enrollment and research data;
- historical housing and rental series where available.

BEA currently provides state GDP interactive tables and maps, and BLS documents historical changes to CPI methodology, including the 1987 revision based on the 1980 Census and 1982–84 expenditure weights. urlBEA GDP by Statehttps://bea.gov/data/gdp/gdp-state urlBLS CPI historical methodologyhttps://www.bls.gov/cpi/additional-resources/historical-changes.htm

## 12. Golden conclusion

The strongest norm is **not** 'a famous programmer deserves a certain number of cities.'

The stronger norm is:

> **A society should measure the economic, institutional and family conditions surrounding important technical work, compare those conditions fairly across time and geography, and support productive human capital when the measured public return exceeds the cost.**

The 4-city and 12-city figures are useful starting parameters for that analysis. They should remain explicitly labeled as **project heuristics** until calibrated against historical metropolitan data.

## Sources

- GNU GCC contributor history: urlGCC Contributorshttps://gcc.gnu.org/onlinedocs/gcc/Contributors.html
- Historical GCC contributor record: urlGCC 3.0 Contributorshttps://gcc.gnu.org/onlinedocs/gcc-3.0.4/gcc/Contributors.html
- BEA GDP by State: urlBEA GDP by Statehttps://bea.gov/data/gdp/gdp-state
- BLS/FRED historical CPI: urlBLS CPI serieshttps://fred.stlouisfed.org/data/USACPIBLS
- Historical real U.S. GDP: urlFRED real GDP serieshttps://fred.stlouisfed.org/data/NGDPRXDCUSA
- BLS CPI methodology history: urlBLS CPI methodology historyhttps://www.bls.gov/cpi/additional-resources/historical-changes.htm
