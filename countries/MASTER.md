# Countries — Master Data Pull Tracker

This is the master tracking document for the world statistical archive. It lists every sovereign country (UN members plus widely-recognized states) and records whether we have pulled their data into the archive.

- **Status legend:** `✅ Pulled` = populated source data in the archive; `🏗 Builder ready` = source-aware builder + scaffold committed, data populates on first CI run; `⬜ Not started` = nothing yet.
- **Location:** Per-country data lives under `national/<country>/`.
- **Have data:** `national/china`, `national/korea`, `national/greenland` (Greenland is an autonomous territory of Denmark, included per existing archive scope).

Archive build: 2026-09-05.

| # | Country | Region | Data Pulled | Notes |
|---|---|---|---|---|
| 1 | Afghanistan | Asia | ✅ Pulled | `national/afghanistan/`; builder + scaffold committed. Bountiful: FAOSTAT (1961+), World Bank WDI, FAO AQUASTAT, OWID. Partial: NSIA yearbooks, MAIL crop estimates. See `national/afghanistan/DATA_SOURCES.md` |
| 2 | Albania | Europe | ✅ Pulled | `national/albania/`; builder+scaffold. Partial: INSTAT. See `national/albania/DATA_SOURCES.md` |
| 3 | Algeria | Africa | ✅ Pulled | `national/algeria/`; builder+scaffold. Partial: ONS. See `national/algeria/DATA_SOURCES.md` |
| 4 | Andorra | Europe | ✅ Pulled | `national/andorra/`; builder+scaffold. Small state — sparse FAOSTAT/WDI expected (honest `N/A`). Partial: Departament d'Estadística |
| 5 | Angola | Africa | ✅ Pulled | `national/angola/`; builder+scaffold. Partial: INE Angola. See `national/angola/DATA_SOURCES.md` |
| 6 | Antigua and Barbuda | Americas | ✅ Pulled | `national/antigua-and-barbuda/`; builder+scaffold. Small state — sparse coverage expected. Partial: Statistics Division |
| 7 | Argentina | Americas | ✅ Pulled | `national/argentina/`; builder+scaffold. Partial: INDEC. See `national/argentina/DATA_SOURCES.md` |
| 8 | Armenia | Asia | ✅ Pulled | `national/armenia/`; builder+scaffold. Partial: ARMSTAT. See `national/armenia/DATA_SOURCES.md` |
| 9 | Australia | Oceania | ✅ Pulled | `national/australia/`; builder+scaffold. Partial: ABS. See `national/australia/DATA_SOURCES.md` |
| 10 | Austria | Europe | ✅ Pulled | `national/austria/`; builder+scaffold. Partial: Statistik Austria. See `national/austria/DATA_SOURCES.md` |
| 11 | Azerbaijan | Asia | ✅ Pulled | `national/azerbaijan/`; builder+scaffold. Partial: AZSTAT. See `national/azerbaijan/DATA_SOURCES.md` |
| 12 | Bahamas | Americas | ✅ Pulled | `national/bahamas/`; small state — sparse coverage expected. Partial: BNSI |
| 13 | Bahrain | Asia | ✅ Pulled | `national/bahrain/`; small state — sparse coverage expected. Partial: iGA |
| 14 | Bangladesh | Asia | ✅ Pulled | `national/bangladesh/`; Partial: BBS. See `national/bangladesh/DATA_SOURCES.md` |
| 15 | Barbados | Americas | ✅ Pulled | `national/barbados/`; small state — sparse coverage expected. Partial: Barbados Statistical Service |
| 16 | Belarus | Europe | ✅ Pulled | `national/belarus/`; Partial: Belstat. See `national/belarus/DATA_SOURCES.md` |
| 17 | Belgium | Europe | ✅ Pulled | `national/belgium/`; Partial: Statbel. See `national/belgium/DATA_SOURCES.md` |
| 18 | Belize | Americas | ✅ Pulled | `national/belize/`; small state — sparse coverage expected. Partial: SIB |
| 19 | Benin | Africa | ✅ Pulled | `national/benin/`; Partial: INStaD. See `national/benin/DATA_SOURCES.md` |
| 20 | Bhutan | Asia | ✅ Pulled | `national/bhutan/`; Partial: NSB. See `national/bhutan/DATA_SOURCES.md` |
| 21 | Bolivia | Americas | ✅ Pulled | `national/bolivia/`; Partial: INE Bolivia. See `national/bolivia/DATA_SOURCES.md` |
| 22 | Bosnia and Herzegovina | Europe | ✅ Pulled | `national/bosnia-and-herzegovina/`; Partial: BHAS. See its `DATA_SOURCES.md` |
| 23 | Botswana | Africa | ✅ Pulled | `national/botswana/`; Partial: Statistics Botswana |
| 24 | Brazil | Americas | ✅ Pulled | `national/brazil/`; Partial: IBGE. See its `DATA_SOURCES.md` |
| 25 | Brunei | Asia | ✅ Pulled | `national/brunei/`; small economy — sparse coverage expected. Partial: DEPS |
| 26 | Bulgaria | Europe | ✅ Pulled | `national/bulgaria/`; Partial: NSI |
| 27 | Burkina Faso | Africa | ✅ Pulled | `national/burkina-faso/`; Partial: INSD |
| 28 | Burundi | Africa | ✅ Pulled | `national/burundi/`; Partial: ISTEEBU |
| 29 | Cabo Verde | Africa | ✅ Pulled | `national/cabo-verde/`; small state — sparse coverage expected. Partial: INE Cabo Verde |
| 30 | Cambodia | Asia | ✅ Pulled | `national/cambodia/`; Partial: NIS |
| 31 | Cameroon | Africa | ✅ Pulled | `national/cameroon/`; Partial: INS Cameroon |
| 32 | Canada | Americas | ⬜ Not started | |
| 33 | Central African Republic | Africa | ⬜ Not started | |
| 34 | Chad | Africa | ⬜ Not started | |
| 35 | Chile | Americas | ⬜ Not started | |
| 36 | China | Asia | ✅ Pulled | Directory `national/china/` |
| 37 | Colombia | Americas | ⬜ Not started | |
| 38 | Comoros | Africa | ⬜ Not started | |
| 39 | Congo (Republic) | Africa | ⬜ Not started | |
| 40 | Congo (DRC) | Africa | ⬜ Not started | |
| 41 | Costa Rica | Americas | ⬜ Not started | |
| 42 | Côte d'Ivoire | Africa | ⬜ Not started | |
| 43 | Croatia | Europe | ⬜ Not started | |
| 44 | Cuba | Americas | ⬜ Not started | |
| 45 | Cyprus | Asia | ⬜ Not started | |
| 46 | Czechia | Europe | ⬜ Not started | |
| 47 | Denmark | Europe | ⬜ Not started | |
| 48 | Djibouti | Africa | ⬜ Not started | |
| 49 | Dominica | Americas | ⬜ Not started | |
| 50 | Dominican Republic | Americas | ⬜ Not started | |
| 51 | Ecuador | Americas | ⬜ Not started | |
| 52 | Egypt | Africa | ⬜ Not started | |
| 53 | El Salvador | Americas | ⬜ Not started | |
| 54 | Equatorial Guinea | Africa | ⬜ Not started | |
| 55 | Eritrea | Africa | ⬜ Not started | |
| 56 | Estonia | Europe | ⬜ Not started | |
| 57 | Eswatini | Africa | ⬜ Not started | |
| 58 | Ethiopia | Africa | ⬜ Not started | |
| 59 | Fiji | Oceania | ⬜ Not started | |
| 60 | Finland | Europe | ⬜ Not started | |
| 61 | France | Europe | ⬜ Not started | |
| 62 | Gabon | Africa | ⬜ Not started | |
| 63 | Gambia | Africa | ⬜ Not started | |
| 64 | Georgia | Asia | ⬜ Not started | |
| 65 | Germany | Europe | ⬜ Not started | |
| 66 | Ghana | Africa | ⬜ Not started | |
| 67 | Greece | Europe | ⬜ Not started | |
| 68 | Greenland | Americas | ✅ Pulled | Directory `national/greenland/`; autonomous territory of Denmark |
| 69 | Grenada | Americas | ⬜ Not started | |
| 70 | Guatemala | Americas | ⬜ Not started | |
| 71 | Guinea | Africa | ⬜ Not started | |
| 72 | Guinea-Bissau | Africa | ⬜ Not started | |
| 73 | Guyana | Americas | ⬜ Not started | |
| 74 | Haiti | Americas | ⬜ Not started | |
| 75 | Honduras | Americas | ⬜ Not started | |
| 76 | Hungary | Europe | ⬜ Not started | |
| 77 | Iceland | Europe | ⬜ Not started | |
| 78 | India | Asia | ⬜ Not started | |
| 79 | Indonesia | Asia | ⬜ Not started | |
| 80 | Iran | Asia | ⬜ Not started | |
| 81 | Iraq | Asia | ⬜ Not started | |
| 82 | Ireland | Europe | ⬜ Not started | |
| 83 | Israel | Asia | ⬜ Not started | |
| 84 | Italy | Europe | ⬜ Not started | |
| 85 | Jamaica | Americas | ⬜ Not started | |
| 86 | Japan | Asia | ⬜ Not started | |
| 87 | Jordan | Asia | ⬜ Not started | |
| 88 | Kazakhstan | Asia | ⬜ Not started | |
| 89 | Kenya | Africa | ⬜ Not started | |
| 90 | Kiribati | Oceania | ⬜ Not started | |
| 91 | Korea (North & South) | Asia | ✅ Pulled | Directory `national/korea/`; data pulled is Republic of Korea (South). North Korea (DPRK) not yet pulled |
| 92 | Kosovo | Europe | ⬜ Not started | Partially recognized |
| 93 | Kuwait | Asia | ⬜ Not started | |
| 94 | Kyrgyzstan | Asia | ⬜ Not started | |
| 95 | Laos | Asia | ⬜ Not started | |
| 96 | Latvia | Europe | ⬜ Not started | |
| 97 | Lebanon | Asia | ⬜ Not started | |
| 98 | Lesotho | Africa | ⬜ Not started | |
| 99 | Liberia | Africa | ⬜ Not started | |
| 100 | Libya | Africa | ⬜ Not started | |
| 101 | Liechtenstein | Europe | ⬜ Not started | |
| 102 | Lithuania | Europe | ⬜ Not started | |
| 103 | Luxembourg | Europe | ⬜ Not started | |
| 104 | Madagascar | Africa | ⬜ Not started | |
| 105 | Malawi | Africa | ⬜ Not started | |
| 106 | Malaysia | Asia | ⬜ Not started | |
| 107 | Maldives | Asia | ⬜ Not started | |
| 108 | Mali | Africa | ⬜ Not started | |
| 109 | Malta | Europe | ⬜ Not started | |
| 110 | Marshall Islands | Oceania | ⬜ Not started | |
| 111 | Mauritania | Africa | ⬜ Not started | |
| 112 | Mauritius | Africa | ⬜ Not started | |
| 113 | Mexico | Americas | ⬜ Not started | |
| 114 | Micronesia | Oceania | ⬜ Not started | |
| 115 | Moldova | Europe | ⬜ Not started | |
| 116 | Monaco | Europe | ⬜ Not started | |
| 117 | Mongolia | Asia | ⬜ Not started | |
| 118 | Montenegro | Europe | ⬜ Not started | |
| 119 | Morocco | Africa | ⬜ Not started | |
| 120 | Mozambique | Africa | ⬜ Not started | |
| 121 | Myanmar | Asia | ⬜ Not started | |
| 122 | Namibia | Africa | ⬜ Not started | |
| 123 | Nauru | Oceania | ⬜ Not started | |
| 124 | Nepal | Asia | ⬜ Not started | |
| 125 | Netherlands | Europe | ⬜ Not started | |
| 126 | New Zealand | Oceania | ⬜ Not started | |
| 127 | Nicaragua | Americas | ⬜ Not started | |
| 128 | Niger | Africa | ⬜ Not started | |
| 129 | Nigeria | Africa | ⬜ Not started | |
| 130 | North Macedonia | Europe | ⬜ Not started | |
| 131 | Norway | Europe | ⬜ Not started | |
| 132 | Oman | Asia | ⬜ Not started | |
| 133 | Pakistan | Asia | ⬜ Not started | |
| 134 | Palau | Oceania | ⬜ Not started | |
| 135 | Palestine | Asia | ⬜ Not started | Partially recognized |
| 136 | Panama | Americas | ⬜ Not started | |
| 137 | Papua New Guinea | Oceania | ⬜ Not started | |
| 138 | Paraguay | Americas | ⬜ Not started | |
| 139 | Peru | Americas | ⬜ Not started | |
| 140 | Philippines | Asia | ⬜ Not started | |
| 141 | Poland | Europe | ⬜ Not started | |
| 142 | Portugal | Europe | ⬜ Not started | |
| 143 | Qatar | Asia | ⬜ Not started | |
| 144 | Romania | Europe | ⬜ Not started | |
| 145 | Russia | Europe/Asia | ⬜ Not started | |
| 146 | Rwanda | Africa | ⬜ Not started | |
| 147 | Saint Kitts and Nevis | Americas | ⬜ Not started | |
| 148 | Saint Lucia | Americas | ⬜ Not started | |
| 149 | Saint Vincent and the Grenadines | Americas | ⬜ Not started | |
| 150 | Samoa | Oceania | ⬜ Not started | |
| 151 | San Marino | Europe | ⬜ Not started | |
| 152 | Sao Tome and Principe | Africa | ⬜ Not started | |
| 153 | Saudi Arabia | Asia | ⬜ Not started | |
| 154 | Senegal | Africa | ⬜ Not started | |
| 155 | Serbia | Europe | ⬜ Not started | |
| 156 | Seychelles | Africa | ⬜ Not started | |
| 157 | Sierra Leone | Africa | ⬜ Not started | |
| 158 | Singapore | Asia | ⬜ Not started | |
| 159 | Slovakia | Europe | ⬜ Not started | |
| 160 | Slovenia | Europe | ⬜ Not started | |
| 161 | Solomon Islands | Oceania | ⬜ Not started | |
| 162 | Somalia | Africa | ⬜ Not started | |
| 163 | South Africa | Africa | ⬜ Not started | |
| 164 | South Sudan | Africa | ⬜ Not started | |
| 165 | Spain | Europe | ⬜ Not started | |
| 166 | Sri Lanka | Asia | ⬜ Not started | |
| 167 | Sudan | Africa | ⬜ Not started | |
| 168 | Suriname | Americas | ⬜ Not started | |
| 169 | Sweden | Europe | ⬜ Not started | |
| 170 | Switzerland | Europe | ⬜ Not started | |
| 171 | Syria | Asia | ⬜ Not started | |
| 172 | Taiwan | Asia | ⬜ Not started | Partially recognized |
| 173 | Tajikistan | Asia | ⬜ Not started | |
| 174 | Tanzania | Africa | ⬜ Not started | |
| 175 | Thailand | Asia | ⬜ Not started | |
| 176 | Timor-Leste | Asia | ⬜ Not started | |
| 177 | Togo | Africa | ⬜ Not started | |
| 178 | Tonga | Oceania | ⬜ Not started | |
| 179 | Trinidad and Tobago | Americas | ⬜ Not started | |
| 180 | Tunisia | Africa | ⬜ Not started | |
| 181 | Turkey | Asia/Europe | ⬜ Not started | |
| 182 | Turkmenistan | Asia | ⬜ Not started | |
| 183 | Tuvalu | Oceania | ⬜ Not started | |
| 184 | Uganda | Africa | ⬜ Not started | |
| 185 | Ukraine | Europe | ⬜ Not started | |
| 186 | United Arab Emirates | Asia | ⬜ Not started | |
| 187 | United Kingdom | Europe | ⬜ Not started | |
| 188 | United States | Americas | ⬜ Not started | |
| 189 | Uruguay | Americas | ⬜ Not started | |
| 190 | Uzbekistan | Asia | ⬜ Not started | |
| 191 | Vanuatu | Oceania | ⬜ Not started | |
| 192 | Vatican City | Europe | ⬜ Not started | Holy See |
| 193 | Venezuela | Americas | ⬜ Not started | |
| 194 | Vietnam | Asia | ⬜ Not started | |
| 195 | Yemen | Asia | ⬜ Not started | |
| 196 | Zambia | Africa | ⬜ Not started | |
| 197 | Zimbabwe | Africa | ⬜ Not started | |

## Summary

- **Total entries listed:** 197 (193 UN members with the two Koreas combined into one entry, + Vatican City, Palestine, Kosovo, Taiwan, and Greenland as territory)
- **Data pulled (✅):** 34 — through Cameroon alphabetically (China, Korea (South), Greenland, Afghanistan and Albania→Cameroon). All populated with real FAOSTAT/World Bank/AQUASTAT data via CI; sparse `N/A` where sources have no observation — small states expectedly sparse.
- **Remaining (⬜):** 163

## Sources

Each country records its own graded source landscape in `national/<country>/DATA_SOURCES.md`.
Sources are graded by how much continuous, machine-readable, per-year data they yield for
the 1965-2026 archive:

- **BOUNTIFUL** — deep, structured, machine-readable time series suitable for the automated builders.
- **PARTIAL** — valuable but discontinuous or document-based; recorded and used for table-level supplementation.
- **Ignored for now** — single studies, preprints, and narrative-only reports without an extractable per-year national series.

### Archive-wide bountiful families

These international families are reproducible baselines used across countries by the builders:

| Source | Domains | Coverage | Access |
|---|---|---|---|
| **FAOSTAT** (Crops & Livestock Products, QCL) | Agriculture, grains, produce, meat, livestock, vegetables, fruit | 245+ countries, **1961**→present | https://www.fao.org/faostat/en/ · bulk: https://bulks-faostat.fao.org/production/ |
| **World Bank WDI** | Economy, agricultural land/employment | Per-country, varies by indicator | https://data.worldbank.org · API: https://api.worldbank.org/v2/country/{ISO3}/indicator/{code} |
| **FAO AQUASTAT** | Water (freshwater withdrawal, resources) | 180+ variables, per country | https://www.fao.org/aquastat/en/databases/ |
| **Our World in Data** | Reproducible CSV layer over FAO/WB series | Per-country, varies | https://ourworldindata.org/agricultural-production |

### Per-country primary families (BOUNTIFUL / PARTIAL as noted)

| Country | Primary source(s) | Grade | Notes |
|---|---|---|---|
| Afghanistan | NSIA statistical yearbooks; MAIL crop estimates | PARTIAL | Strongest post-2008; see `national/afghanistan/DATA_SOURCES.md` |
| Albania | INSTAT (Institute of Statistics) | PARTIAL | see `national/albania/DATA_SOURCES.md` |
| Algeria | ONS (Office National des Statistiques) | PARTIAL | see `national/algeria/DATA_SOURCES.md` |
| Andorra | Departament d'Estadística | PARTIAL | small state; sparse FAOSTAT/WDI expected |
| Angola | INE Angola | PARTIAL | see `national/angola/DATA_SOURCES.md` |
| Antigua and Barbuda | Statistics Division | PARTIAL | small state; sparse coverage expected |
| Argentina | INDEC | PARTIAL | see `national/argentina/DATA_SOURCES.md` |
| Armenia | ARMSTAT | PARTIAL | see `national/armenia/DATA_SOURCES.md` |
| Australia | ABS (Australian Bureau of Statistics) | PARTIAL | strong national data; see `national/australia/DATA_SOURCES.md` |
| Austria | Statistik Austria | PARTIAL | see `national/austria/DATA_SOURCES.md` |
| Azerbaijan | AZSTAT (State Statistical Committee) | PARTIAL | see `national/azerbaijan/DATA_SOURCES.md` |
| Bahamas | BNSI | PARTIAL | small state; sparse coverage expected |
| Bahrain | iGA (Information & eGovernment Authority) | PARTIAL | small state; sparse coverage expected |
| Bangladesh | BBS (Bangladesh Bureau of Statistics) | PARTIAL | see `national/bangladesh/DATA_SOURCES.md` |
| Barbados | Barbados Statistical Service | PARTIAL | small state; sparse coverage expected |
| Belarus | Belstat | PARTIAL | see `national/belarus/DATA_SOURCES.md` |
| Belgium | Statbel | PARTIAL | see `national/belgium/DATA_SOURCES.md` |
| Belize | SIB (Statistical Institute of Belize) | PARTIAL | small state; sparse coverage expected |
| Benin | INStaD | PARTIAL | see `national/benin/DATA_SOURCES.md` |
| Bhutan | NSB (National Statistics Bureau) | PARTIAL | see `national/bhutan/DATA_SOURCES.md` |
| Bolivia | INE Bolivia | PARTIAL | see `national/bolivia/DATA_SOURCES.md` |
| Bosnia and Herzegovina | BHAS | PARTIAL | see `national/bosnia-and-herzegovina/DATA_SOURCES.md` |
| Botswana | Statistics Botswana | PARTIAL | see `national/botswana/DATA_SOURCES.md` |
| Brazil | IBGE | PARTIAL | see `national/brazil/DATA_SOURCES.md` |
| Brunei | DEPS | PARTIAL | small economy; sparse coverage expected |
| Bulgaria | NSI | PARTIAL | see `national/bulgaria/DATA_SOURCES.md` |
| Burkina Faso | INSD | PARTIAL | see `national/burkina-faso/DATA_SOURCES.md` |
| Burundi | ISTEEBU | PARTIAL | see `national/burundi/DATA_SOURCES.md` |
| Cabo Verde | INE Cabo Verde | PARTIAL | small state; sparse coverage expected |
| Cambodia | NIS | PARTIAL | see `national/cambodia/DATA_SOURCES.md` |
| Cameroon | INS Cameroon | PARTIAL | see `national/cameroon/DATA_SOURCES.md` |
| China | (see `national/china/`) | — | existing archive |
| Korea (South) | KOSIS; MAFRA/KASS; KAMIS; Bank of Korea | BOUNTIFUL | see `national/korea/DATA_SOURCES.md` |
| Greenland | (see `national/greenland/`) | — | existing archive |

> Note: values are populated by the per-country builders in `tools/<country>/`, which fetch
> these sources at build time (via GitHub Actions). They perform no interpolation and write
> `N/A` where a source has no observation.
