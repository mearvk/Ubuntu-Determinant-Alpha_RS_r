# Korea Data Sources and Initial Verified Data Pass

## Verified source families

### KOSIS
KOSIS is the Korean Statistical Information Service and exposes statistical databases for agriculture and forestry, economy and market, prices, national accounts, environment, and other domains. Its public statistical dashboard also exposes long historical indicator years, including 1965 onward for some series. Historical coverage therefore varies by indicator and must be checked table-by-table.

### KAMIS
KAMIS provides agricultural, livestock, and fishery market-price information. Its current public pages expose annual, monthly, daily, and historical retail series. The annual retail view is suitable for controlled transcription of commodity prices; the site also documents that prices are reference averages and may differ from individual sellers, origins, brands, and specifications.

A historical KAMIS annual example available during this research pass contains annual oyster retail observations back through the 1990s. This demonstrates that useful historical price depth exists, but it does not establish that every commodity has the same start year.

### MAFRA
The Ministry of Agriculture, Food and Rural Affairs publishes the annual agricultural and food statistical yearbook. The 2025 statistical yearbook was published in 2026 and is an important current anchor for agriculture, food, and livestock series.

### Bank of Korea
The Bank of Korea publishes national accounts and methodological documentation. Its 2025 national-accounts release provides current macroeconomic observations and a documented national-accounts framework.

## Current observations captured for later structured transcription

- KAMIS 2026 annual retail page currently reports annual commodity averages, including rice and other food commodities.
- Bank of Korea's 2025 national-accounts release reports nominal GDP of KRW 2,676.7 trillion and real GDP growth of 1.1% for 2025 in the June 2026 finalized/preliminary release context.
- Statistics Korea's 2024 Farm Household Sale and Purchase Price Survey reports a farm-gate sale price index of 116.3, a farm purchase price index of 120.1, and a terms-of-trade index of 96.8.

These observations are source anchors, not substitutes for year-by-year extraction. The annual files intentionally retain `PENDING_SOURCE` where a precise historical observation has not yet been transcribed and validated.

## Next extraction priorities

1. KOSIS long-run agricultural production, cultivated area, livestock inventory, and farm-household series.
2. KAMIS commodity price series with stable definitions and documented start dates.
3. MAFRA yearbook tables for agriculture, food, livestock, and forestry.
4. Bank of Korea national accounts for GDP and related macro series.
5. Water statistics from compatible Korean government and FAO/AQUASTAT sources.
