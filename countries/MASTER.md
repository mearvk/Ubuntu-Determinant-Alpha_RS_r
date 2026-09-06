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
| 32 | Canada | Americas | ✅ Pulled | `national/canada/`; Partial: Statistics Canada |
| 33 | Central African Republic | Africa | ✅ Pulled | `national/central-african-republic/`; Partial: ICASEES |
| 34 | Chad | Africa | ✅ Pulled | `national/chad/`; Partial: INSEED |
| 35 | Chile | Americas | ✅ Pulled | `national/chile/`; Partial: INE Chile |
| 36 | China | Asia | ✅ Pulled | Directory `national/china/` |
| 37 | Colombia | Americas | ✅ Pulled | `national/colombia/`; Partial: DANE |
| 38 | Comoros | Africa | ✅ Pulled | `national/comoros/`; small state — sparse coverage expected. Partial: INSEED Comoros |
| 39 | Congo (Republic) | Africa | ✅ Pulled | `national/congo-republic/`; FAOSTAT entity "Congo". Partial: INS Congo |
| 40 | Congo (DRC) | Africa | ✅ Pulled | `national/congo-drc/`; FAOSTAT entity "Democratic Republic of the Congo". Partial: INS RDC |
| 41 | Costa Rica | Americas | ✅ Pulled | `national/costa-rica/`; Partial: INEC |
| 42 | Côte d'Ivoire | Africa | ✅ Pulled | `national/cote-divoire/`; Partial: INS Côte d'Ivoire |
| 43 | Croatia | Europe | ✅ Pulled | `national/croatia/`; Partial: DZS |
| 44 | Cuba | Americas | ✅ Pulled | `national/cuba/`; Partial: ONEI |
| 45 | Cyprus | Asia | ✅ Pulled | `national/cyprus/`; small state — sparse coverage expected. Partial: CYSTAT |
| 46 | Czechia | Europe | ✅ Pulled | `national/czechia/`; Partial: CZSO |
| 47 | Denmark | Europe | ✅ Pulled | `national/denmark/`; Partial: Statistics Denmark |
| 48 | Djibouti | Africa | ✅ Pulled | `national/djibouti/`; small state — sparse coverage expected. Partial: INSTAD |
| 49 | Dominica | Americas | ✅ Pulled | `national/dominica/`; small state — sparse coverage expected. Partial: Central Statistics Office |
| 50 | Dominican Republic | Americas | ✅ Pulled | `national/dominican-republic/`; Partial: ONE |
| 51 | Ecuador | Americas | ✅ Pulled | `national/ecuador/`; Partial: INEC |
| 52 | Egypt | Africa | ✅ Pulled | `national/egypt/`; Partial: CAPMAS |
| 53 | El Salvador | Americas | ✅ Pulled | `national/el-salvador/`; Partial: ONEC (formerly DIGESTYC) |
| 54 | Equatorial Guinea | Africa | ✅ Pulled | `national/equatorial-guinea/`; small economy — sparse coverage expected. Partial: INEGE |
| 55 | Eritrea | Africa | ✅ Pulled | `national/eritrea/`; small/limited data — sparse coverage expected. Partial: National Statistics Office |
| 56 | Estonia | Europe | ✅ Pulled | `national/estonia/`; Partial: Statistics Estonia |
| 57 | Eswatini | Africa | ✅ Pulled | `national/eswatini/`; small state — sparse coverage expected. Partial: CSO Eswatini |
| 58 | Ethiopia | Africa | ✅ Pulled | `national/ethiopia/`; FAOSTAT entity "Ethiopia" (post-1993; pre-1993 under Ethiopia PDR → `N/A`). Partial: ESS |
| 59 | Fiji | Oceania | ✅ Pulled | `national/fiji/`; small state — sparse coverage expected. Partial: FBoS |
| 60 | Finland | Europe | ✅ Pulled | `national/finland/`; Partial: Statistics Finland |
| 61 | France | Europe | ✅ Pulled | `national/france/`; Partial: INSEE |
| 62 | Gabon | Africa | ✅ Pulled | `national/gabon/`; Partial: DGS Gabon |
| 63 | Gambia | Africa | ✅ Pulled | `national/gambia/`; small state — sparse coverage expected. Partial: GBoS |
| 64 | Georgia | Asia | ✅ Pulled | `national/georgia/`; Partial: Geostat |
| 65 | Germany | Europe | ✅ Pulled | `national/germany/`; Partial: Destatis |
| 66 | Ghana | Africa | ✅ Pulled | `national/ghana/`; Partial: GSS |
| 67 | Greece | Europe | ✅ Pulled | `national/greece/`; Partial: ELSTAT |
| 68 | Greenland | Americas | ✅ Pulled | Directory `national/greenland/`; autonomous territory of Denmark |
| 69 | Grenada | Americas | ✅ Pulled | `national/grenada/`; small state — sparse coverage expected. Partial: CSO Grenada |
| 70 | Guatemala | Americas | ✅ Pulled | `national/guatemala/`; Partial: INE Guatemala |
| 71 | Guinea | Africa | ✅ Pulled | `national/guinea/`; Partial: INS Guinea |
| 72 | Guinea-Bissau | Africa | ✅ Pulled | `national/guinea-bissau/`; small state — sparse coverage expected. Partial: INE Guinea-Bissau |
| 73 | Guyana | Americas | ✅ Pulled | `national/guyana/`; small state — sparse coverage expected. Partial: Bureau of Statistics |
| 74 | Haiti | Americas | ✅ Pulled | `national/haiti/`; Partial: IHSI |
| 75 | Honduras | Americas | ✅ Pulled | `national/honduras/`; Partial: INE Honduras |
| 76 | Hungary | Europe | ✅ Pulled | `national/hungary/`; Partial: KSH |
| 77 | Iceland | Europe | ✅ Pulled | `national/iceland/`; small state — sparse coverage expected. Partial: Statistics Iceland |
| 78 | India | Asia | ✅ Pulled | `national/india/`; Partial: MoSPI/NSO |
| 79 | Indonesia | Asia | ✅ Pulled | `national/indonesia/`; Partial: BPS |
| 80 | Iran | Asia | ✅ Pulled | `national/iran/`; FAOSTAT entity "Iran (Islamic Republic of)". Partial: SCI |
| 81 | Iraq | Asia | ✅ Pulled | `national/iraq/`; Partial: CSO/COSIT |
| 82 | Ireland | Europe | ✅ Pulled | `national/ireland/`; Partial: CSO Ireland |
| 83 | Israel | Asia | ✅ Pulled | `national/israel/`; Partial: CBS Israel |
| 84 | Italy | Europe | ✅ Pulled | `national/italy/`; Partial: ISTAT |
| 85 | Jamaica | Americas | ✅ Pulled | `national/jamaica/`; small state — sparse coverage expected. Partial: STATIN |
| 86 | Japan | Asia | ✅ Pulled | `national/japan/`; Partial: Statistics Bureau of Japan |
| 87 | Jordan | Asia | ✅ Pulled | `national/jordan/`; Partial: DoS Jordan |
| 88 | Kazakhstan | Asia | ✅ Pulled | `national/kazakhstan/`; Partial: Bureau of National Statistics |
| 89 | Kenya | Africa | ✅ Pulled | `national/kenya/`; Partial: KNBS |
| 90 | Kiribati | Oceania | ✅ Pulled | `national/kiribati/`; small state — sparse coverage expected. Partial: Kiribati NSO |
| 91 | Korea (North & South) | Asia | ✅ Pulled | Directory `national/korea/`; data pulled is Republic of Korea (South). North Korea (DPRK) not yet pulled |
| 92 | Kosovo | Europe | ✅ Pulled | `national/kosovo/`; partially recognized — no FAOSTAT entity, so WDI-only (crop cells `N/A`). Partial: ASK |
| 93 | Kuwait | Asia | ✅ Pulled | `national/kuwait/`; small/desert economy — sparse agriculture. Partial: CSB Kuwait |
| 94 | Kyrgyzstan | Asia | ✅ Pulled | `national/kyrgyzstan/`; Partial: Natstatcom |
| 95 | Laos | Asia | ✅ Pulled | `national/laos/`; FAOSTAT entity "Lao People's Democratic Republic". Partial: LSB |
| 96 | Latvia | Europe | ✅ Pulled | `national/latvia/`; Partial: CSB Latvia |
| 97 | Lebanon | Asia | ✅ Pulled | `national/lebanon/`; Partial: CAS Lebanon |
| 98 | Lesotho | Africa | ✅ Pulled | `national/lesotho/`; small state — sparse coverage expected. Partial: BOS Lesotho |
| 99 | Liberia | Africa | ✅ Pulled | `national/liberia/`; small economy — sparse coverage expected. Partial: LISGIS |
| 100 | Libya | Africa | ✅ Pulled | `national/libya/`; desert economy — sparse agriculture. Partial: Bureau of Statistics & Census |
| 101 | Liechtenstein | Europe | ✅ Pulled | `national/liechtenstein/`; microstate — no FAOSTAT entity, WDI-only (crop cells `N/A`). Partial: Office of Statistics |
| 102 | Lithuania | Europe | ✅ Pulled | `national/lithuania/`; Partial: Statistics Lithuania |
| 103 | Luxembourg | Europe | ✅ Pulled | `national/luxembourg/`; small state — sparse coverage expected. Partial: STATEC |
| 104 | Madagascar | Africa | ✅ Pulled | `national/madagascar/`; Partial: INSTAT Madagascar |
| 105 | Malawi | Africa | ✅ Pulled | `national/malawi/`; Partial: NSO Malawi |
| 106 | Malaysia | Asia | ✅ Pulled | `national/malaysia/`; Partial: DOSM |
| 107 | Maldives | Asia | ✅ Pulled | `national/maldives/`; small island state — sparse coverage expected. Partial: Maldives Bureau of Statistics |
| 108 | Mali | Africa | ✅ Pulled | `national/mali/`; Partial: INSTAT Mali |
| 109 | Malta | Europe | ✅ Pulled | `national/malta/`; small state — sparse coverage expected. Partial: NSO Malta |
| 110 | Marshall Islands | Oceania | ✅ Pulled | `national/marshall-islands/`; tiny Pacific state — sparse coverage expected. Partial: EPPSO |
| 111 | Mauritania | Africa | ✅ Pulled | `national/mauritania/`; sparse coverage expected. Partial: ANSADE |
| 112 | Mauritius | Africa | ✅ Pulled | `national/mauritius/`; small island state — sparse coverage expected. Partial: Statistics Mauritius |
| 113 | Mexico | Americas | ✅ Pulled | `national/mexico/`; Partial: INEGI |
| 114 | Micronesia | Oceania | ✅ Pulled | `national/micronesia/`; tiny Pacific state, FAOSTAT entity "Micronesia (Federated States of)". Partial: FSM Statistics |
| 115 | Moldova | Europe | ✅ Pulled | `national/moldova/`; FAOSTAT entity "Republic of Moldova". Partial: BNS Moldova |
| 116 | Monaco | Europe | ✅ Pulled | `national/monaco/`; microstate — no FAOSTAT entity, WDI-only (crop cells `N/A`). Partial: IMSEE |
| 117 | Mongolia | Asia | ✅ Pulled | `national/mongolia/`; Partial: NSO Mongolia |
| 118 | Montenegro | Europe | ✅ Pulled | `national/montenegro/`; small state — sparse coverage expected. Partial: MONSTAT |
| 119 | Morocco | Africa | ✅ Pulled | `national/morocco/`; Partial: HCP |
| 120 | Mozambique | Africa | ✅ Pulled | `national/mozambique/`; Partial: INE Mozambique |
| 121 | Myanmar | Asia | ✅ Pulled | `national/myanmar/`; Partial: CSO Myanmar |
| 122 | Namibia | Africa | ✅ Pulled | `national/namibia/`; Partial: NSA Namibia |
| 123 | Nauru | Oceania | ✅ Pulled | `national/nauru/`; microstate — no FAOSTAT entity, WDI-only (crop cells `N/A`). Partial: Nauru Bureau of Statistics |
| 124 | Nepal | Asia | ✅ Pulled | `national/nepal/`; Partial: NSO Nepal |
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
- **Data pulled (✅):** 124 — through Nepal alphabetically (China, Korea (South), Greenland, Afghanistan and Albania→Nepal). All populated with real FAOSTAT/World Bank/AQUASTAT data via CI; sparse `N/A` where sources have no observation — small states and no-FAOSTAT-entity cases (e.g. Kosovo, Liechtenstein, Monaco, Nauru) expectedly sparse.
- **Remaining (⬜):** 73

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
| Canada | Statistics Canada | PARTIAL | see `national/canada/DATA_SOURCES.md` |
| Central African Republic | ICASEES | PARTIAL | see `national/central-african-republic/DATA_SOURCES.md` |
| Chad | INSEED | PARTIAL | see `national/chad/DATA_SOURCES.md` |
| Chile | INE Chile | PARTIAL | see `national/chile/DATA_SOURCES.md` |
| Colombia | DANE | PARTIAL | see `national/colombia/DATA_SOURCES.md` |
| Comoros | INSEED Comoros | PARTIAL | small state; sparse coverage expected |
| Congo (Republic) | INS Congo | PARTIAL | FAOSTAT entity "Congo" |
| Congo (DRC) | INS RDC | PARTIAL | FAOSTAT entity "Democratic Republic of the Congo" |
| Costa Rica | INEC | PARTIAL | see `national/costa-rica/DATA_SOURCES.md` |
| Côte d'Ivoire | INS Côte d'Ivoire | PARTIAL | see `national/cote-divoire/DATA_SOURCES.md` |
| Croatia | DZS | PARTIAL | see `national/croatia/DATA_SOURCES.md` |
| Cuba | ONEI | PARTIAL | see `national/cuba/DATA_SOURCES.md` |
| Cyprus | CYSTAT | PARTIAL | small state; sparse coverage expected |
| Czechia | CZSO | PARTIAL | see `national/czechia/DATA_SOURCES.md` |
| Denmark | Statistics Denmark | PARTIAL | see `national/denmark/DATA_SOURCES.md` |
| Djibouti | INSTAD | PARTIAL | small state; sparse coverage expected |
| Dominica | Central Statistics Office | PARTIAL | small state; sparse coverage expected |
| Dominican Republic | ONE | PARTIAL | see `national/dominican-republic/DATA_SOURCES.md` |
| Ecuador | INEC | PARTIAL | see `national/ecuador/DATA_SOURCES.md` |
| Egypt | CAPMAS | PARTIAL | see `national/egypt/DATA_SOURCES.md` |
| El Salvador | ONEC (ex-DIGESTYC) | PARTIAL | see `national/el-salvador/DATA_SOURCES.md` |
| Equatorial Guinea | INEGE | PARTIAL | small economy; sparse coverage expected |
| Eritrea | National Statistics Office | PARTIAL | limited data; sparse coverage expected |
| Estonia | Statistics Estonia | PARTIAL | see `national/estonia/DATA_SOURCES.md` |
| Eswatini | CSO Eswatini | PARTIAL | small state; sparse coverage expected |
| Ethiopia | ESS (Ethiopian Statistical Service) | PARTIAL | FAOSTAT entity "Ethiopia" (post-1993) |
| Fiji | FBoS | PARTIAL | small state; sparse coverage expected |
| Finland | Statistics Finland | PARTIAL | see `national/finland/DATA_SOURCES.md` |
| France | INSEE | PARTIAL | see `national/france/DATA_SOURCES.md` |
| Gabon | DGS Gabon | PARTIAL | see `national/gabon/DATA_SOURCES.md` |
| Gambia | GBoS | PARTIAL | small state; sparse coverage expected |
| Georgia | Geostat | PARTIAL | see `national/georgia/DATA_SOURCES.md` |
| Germany | Destatis | PARTIAL | see `national/germany/DATA_SOURCES.md` |
| Ghana | GSS | PARTIAL | see `national/ghana/DATA_SOURCES.md` |
| Greece | ELSTAT | PARTIAL | see `national/greece/DATA_SOURCES.md` |
| Grenada | CSO Grenada | PARTIAL | small state; sparse coverage expected |
| Guatemala | INE Guatemala | PARTIAL | see `national/guatemala/DATA_SOURCES.md` |
| Guinea | INS Guinea | PARTIAL | see `national/guinea/DATA_SOURCES.md` |
| Guinea-Bissau | INE Guinea-Bissau | PARTIAL | small state; sparse coverage expected |
| Guyana | Bureau of Statistics Guyana | PARTIAL | small state; sparse coverage expected |
| Haiti | IHSI | PARTIAL | see `national/haiti/DATA_SOURCES.md` |
| Honduras | INE Honduras | PARTIAL | see `national/honduras/DATA_SOURCES.md` |
| Hungary | KSH | PARTIAL | see `national/hungary/DATA_SOURCES.md` |
| Iceland | Statistics Iceland | PARTIAL | small state; sparse coverage expected |
| India | MoSPI/NSO | PARTIAL | see `national/india/DATA_SOURCES.md` |
| Indonesia | BPS | PARTIAL | see `national/indonesia/DATA_SOURCES.md` |
| Iran | SCI | PARTIAL | FAOSTAT entity "Iran (Islamic Republic of)" |
| Iraq | CSO/COSIT | PARTIAL | see `national/iraq/DATA_SOURCES.md` |
| Ireland | CSO Ireland | PARTIAL | see `national/ireland/DATA_SOURCES.md` |
| Israel | CBS Israel | PARTIAL | see `national/israel/DATA_SOURCES.md` |
| Italy | ISTAT | PARTIAL | see `national/italy/DATA_SOURCES.md` |
| Jamaica | STATIN | PARTIAL | small state; sparse coverage expected |
| Japan | Statistics Bureau of Japan | PARTIAL | see `national/japan/DATA_SOURCES.md` |
| Jordan | DoS Jordan | PARTIAL | see `national/jordan/DATA_SOURCES.md` |
| Kazakhstan | Bureau of National Statistics | PARTIAL | see `national/kazakhstan/DATA_SOURCES.md` |
| Kenya | KNBS | PARTIAL | see `national/kenya/DATA_SOURCES.md` |
| Kiribati | Kiribati NSO | PARTIAL | small state; sparse coverage expected |
| Kosovo | ASK | PARTIAL | no FAOSTAT entity; WDI-only, crop cells `N/A` |
| Kuwait | CSB Kuwait | PARTIAL | desert economy; sparse agriculture |
| Kyrgyzstan | Natstatcom | PARTIAL | see `national/kyrgyzstan/DATA_SOURCES.md` |
| Laos | LSB | PARTIAL | FAOSTAT entity "Lao People's Democratic Republic" |
| Latvia | CSB Latvia | PARTIAL | see `national/latvia/DATA_SOURCES.md` |
| Lebanon | CAS Lebanon | PARTIAL | see `national/lebanon/DATA_SOURCES.md` |
| Lesotho | BOS Lesotho | PARTIAL | small state; sparse coverage expected |
| Liberia | LISGIS | PARTIAL | small economy; sparse coverage expected |
| Libya | Bureau of Statistics & Census | PARTIAL | desert economy; sparse agriculture |
| Liechtenstein | Office of Statistics | PARTIAL | microstate; no FAOSTAT entity, WDI-only |
| Lithuania | Statistics Lithuania | PARTIAL | see `national/lithuania/DATA_SOURCES.md` |
| Luxembourg | STATEC | PARTIAL | small state; sparse coverage expected |
| Madagascar | INSTAT Madagascar | PARTIAL | see `national/madagascar/DATA_SOURCES.md` |
| Malawi | NSO Malawi | PARTIAL | see `national/malawi/DATA_SOURCES.md` |
| Malaysia | DOSM | PARTIAL | see `national/malaysia/DATA_SOURCES.md` |
| Maldives | Maldives Bureau of Statistics | PARTIAL | small island state; sparse coverage expected |
| Mali | INSTAT Mali | PARTIAL | see `national/mali/DATA_SOURCES.md` |
| Malta | NSO Malta | PARTIAL | small state; sparse coverage expected |
| Marshall Islands | EPPSO | PARTIAL | tiny Pacific state; sparse coverage expected |
| Mauritania | ANSADE | PARTIAL | sparse coverage expected |
| Mauritius | Statistics Mauritius | PARTIAL | small island state; sparse coverage expected |
| Mexico | INEGI | PARTIAL | see `national/mexico/DATA_SOURCES.md` |
| Micronesia | FSM Statistics | PARTIAL | tiny Pacific state; FAOSTAT entity "Micronesia (Federated States of)" |
| Moldova | BNS Moldova | PARTIAL | FAOSTAT entity "Republic of Moldova" |
| Monaco | IMSEE | PARTIAL | microstate; no FAOSTAT entity, WDI-only |
| Mongolia | NSO Mongolia | PARTIAL | see `national/mongolia/DATA_SOURCES.md` |
| Montenegro | MONSTAT | PARTIAL | small state; sparse coverage expected |
| Morocco | HCP | PARTIAL | see `national/morocco/DATA_SOURCES.md` |
| Mozambique | INE Mozambique | PARTIAL | see `national/mozambique/DATA_SOURCES.md` |
| Myanmar | CSO Myanmar | PARTIAL | see `national/myanmar/DATA_SOURCES.md` |
| Namibia | NSA Namibia | PARTIAL | see `national/namibia/DATA_SOURCES.md` |
| Nauru | Nauru Bureau of Statistics | PARTIAL | microstate; no FAOSTAT entity, WDI-only |
| Nepal | NSO Nepal | PARTIAL | see `national/nepal/DATA_SOURCES.md` |
| China | (see `national/china/`) | — | existing archive |
| Korea (South) | KOSIS; MAFRA/KASS; KAMIS; Bank of Korea | BOUNTIFUL | see `national/korea/DATA_SOURCES.md` |
| Greenland | (see `national/greenland/`) | — | existing archive |

> Note: values are populated by the per-country builders in `tools/<country>/`, which fetch
> these sources at build time (via GitHub Actions). They perform no interpolation and write
> `N/A` where a source has no observation.
