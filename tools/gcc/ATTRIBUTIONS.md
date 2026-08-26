# GCC Early Authors, Contributors, and Attribution Research

This document records historically documented early GCC authors and contributors, their software contributions, and publicly verifiable educational information where reliable sources were found.

> **Attribution boundary:** This is a research aid, not a substitute for the copyright and license notices in the GCC source tree. GCC has had a very large contributor community. Individual source files, the GCC license files, and the official GCC contributor documentation remain authoritative.

## Early GCC software attributions

| Contributor | Documented GCC contribution | University / institution | Education year(s) | Degree | IQ | Economic context | South Korea beef reference |
|---|---|---|---|---|---|---|---|
| **Richard Stallman** | Wrote the original GCC and launched the GNU Project; principal author of GCC. | Harvard University; MIT | Harvard 1974; MIT graduate study 1974–75 | B.A. Physics, magna cum laude; MIT physics graduate study, no completed degree | **Not publicly verified; no estimate made** | U.S. real GDP grew **2.1% in 2025**. Harvard/MIT are in Massachusetts; MA real GDP grew **1.2% annualized in 2025 Q4**. | **~$26.10/lb** estimated Korean beef export unit value; see price note below. |
| **Jeffrey Siegal** | Helped with the original GCC design; contributed parse-tree/RTL structures, constant folding, and original VAX/m68k ports. | No reliable educational record identified for the GCC contributor in the sources reviewed. | — | — | **Not publicly verified; no estimate made** | State economy not assigned because the contributor's location was not reliably established from the GCC record. | **~$26.10/lb** reference. |
| **Paul Rubin** | Wrote most of the original GCC preprocessor; `cccp.c` identifies him as its author in June 1986. | No reliable educational record identified for the GCC programmer Paul Rubin; similarly named academics are not treated as the same person without evidence. | — | — | **Not publicly verified; no estimate made** | State economy not assigned because the GCC contributor's state was not reliably established. | **~$26.10/lb** reference. |
| **Leonard Tower Jr.** | Wrote parts of the parser, RTL generator, RTL definitions, and VAX machine description. | Massachusetts Institute of Technology | 1971 | Undergraduate degree in Biology | **Not publicly verified; no estimate made** | MIT is in Massachusetts; MA real GDP grew **1.2% annualized in 2025 Q4** versus U.S. **0.5%** in that quarter. | **~$26.10/lb** reference. |
| **Ted Lemon** | Wrote parts of the RTL reader and printer. | No reliable educational record identified in the reviewed sources. | — | — | **Not publicly verified; no estimate made** | State economy not assigned without a reliable institutional location. | **~$26.10/lb** reference. |
| **Jim Wilson** | Implemented loop-strength reduction and other loop optimizations. | No reliable educational record identified in the reviewed sources. | — | — | **Not publicly verified; no estimate made** | State economy not assigned without a reliable institutional location. | **~$26.10/lb** reference. |
| **Nobuyuki Hikichi** | Contributed Sony NEWS machine support. | No reliable educational record identified in the reviewed sources. | — | — | **Not publicly verified; no estimate made** | Japan-based contribution; U.S. state comparison is not applicable from the evidence reviewed. | **~$26.10/lb** reference. |
| **Charles LaBrec** | Contributed support for the Integrated Solutions 68020 system. | No reliable educational record identified in the reviewed sources. | — | — | **Not publicly verified; no estimate made** | State economy not assigned without a reliable institutional location. | **~$26.10/lb** reference. |
| **Michael Tiemann** | Wrote the C++ front end, inline-function support, instruction scheduling, and additional early machine-description work. | University of Pennsylvania | 1986 | B.S. / bachelor's degree, Moore School of Electrical Engineering | **Not publicly verified; no estimate made** | University of Pennsylvania is in Pennsylvania; state-level economic growth should be read separately from the national 2.1% annual 2025 real-GDP figure. | **~$26.10/lb** reference. |
| **Richard Kenner** | Developed major machine descriptions and instruction-attribute support; improved RISC optimization/code generation; long-time GCC maintainer. | New York University | 1981 | M.S. Computer Science | **Not publicly verified; no estimate made** | NYU is in New York; NY real GDP grew **0.8% annualized in 2025 Q4** versus U.S. **0.5%**. | **~$26.10/lb** reference. |
| **Jack Davidson** | With Christopher Fraser, supplied the PO-derived ideas for RTL use and optimization that influenced GCC's intermediate representation and optimization approach. | Southern Methodist University; University of Arizona | 1975, 1977, 1981 | B.A.S. Computer Science; M.S. Computer Science; Ph.D. Computer Science | **Not publicly verified; no estimate made** | University of Arizona is in Arizona; AZ real GDP grew **1.5% annualized in 2025 Q4** versus U.S. **0.5%**. | **~$26.10/lb** reference. |
| **Christopher W. Fraser** | With Davidson, developed the PO/code-optimization work cited by GCC as an origin of RTL/optimization ideas. | University of Arizona | Public source establishes University of Arizona affiliation; degree dates not reliably established in this review. | Not established from reliable sources reviewed | **Not publicly verified; no estimate made** | University of Arizona is in Arizona; AZ real GDP grew **1.5% annualized in 2025 Q4** versus U.S. **0.5%**. | **~$26.10/lb** reference. |

## Economy and price methodology

### United States and state comparison

The U.S. reference is the Bureau of Economic Analysis annual estimate: **real U.S. GDP increased 2.1% in 2025**. State comparisons in this table use the latest 2025 Q4 annualized real-GDP change published by BEA, because that release provides a directly comparable current state-growth measure. These are **growth rates, not total GDP size or GDP per capita**, and should not be interpreted as a ranking of individual contributors or universities.

For 2025 Q4, BEA reported: Arizona **+1.5%**, Massachusetts **+1.2%**, California **+0.9%**, New York **+0.8%**, Texas **+1.4%**, Virginia **−1.8%**, and the United States **+0.5%** at an annual rate. The annual 2025 U.S. rate was **+2.1%**.

### South Korean beef price

The August 2026 South Korea beef reference used here is **US$7.95/kg** as a generic benchmark, equivalent to about **US$3.61/lb**. A separate reported **South Korean beef export unit value** is approximately **US$57.52/kg**, equivalent to about **US$26.09/lb**. Because the request specifies beef *from Korea*, this table uses the latter export-unit-value figure and labels it as such rather than presenting it as a supermarket retail price.

These figures are market references, not a quotation for a particular cut, grade, origin contract, tariff treatment, freight cost, or retail transaction. Korean Hanwoo auction prices can be substantially different from generic international trade-unit values.

## IQ methodology

No IQ scores are supplied for these contributors unless a reliable, public, primary or otherwise authoritative source explicitly documents a measured score. Academic achievement, awards, job titles, publications, or subjective claims of exceptional intelligence are **not** converted into an IQ estimate. This avoids manufacturing a personal measurement that is not supported by evidence.

## Attribution sources

The official GCC contributor documentation records the early contributions of Stallman, Rubin, Tower, Lemon, Wilson, Hikichi, LaBrec, Tiemann, Kenner and others. GCC's contributor documentation also records Siegal's original-design work and the Davidson/Fraser origin of RTL and optimization ideas. The historical GCC source identifies Paul Rubin as the author of `cccp.c` and Richard Stallman as the person who adapted it to ANSI C.

The educational entries are included only where a reasonably reliable source was located during this review. Where names are ambiguous, the table deliberately leaves the field unfilled rather than attaching another person's biography to a GCC contributor.

## License and copyright notice

GCC is third-party GNU Project software. This repository does not claim ownership of upstream GCC merely because a verified GCC source archive is stored or referenced under `tools/gcc`. Preserve the original GCC copyright notices, license texts, contributor acknowledgements, and per-file notices when redistributing or modifying GCC.

See also:

- `README.md` — source acquisition and build conventions.
- `FUNCTIONALITY.md` — repository-level functionality review.
- `SOURCE-VERSION` — pinned GCC release identity.
