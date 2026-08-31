# VOCABULARY.md

Results of a full, end-to-end run of the byte-level BPE vocabulary-growth
pipeline (`tools/ai/bpe/`) against the complete A–Z Webster's 1913 dictionary.
This document records the run parameters, the measured outcome, and a careful
table of every **new whole-word token** that was defined from the dictionary.

> Reproducibility: every number and word below is generated from the pipeline
> artifacts (`tools/ai/bpe/out/`), not hand-entered. Regenerate with the
> commands in [`tools/ai/bpe/README.md`](tools/ai/bpe/README.md). No definitions
> are fabricated — words absent from the dictionary are reported as
> `needs_definition`.

---

## 1. Run configuration

| Parameter | Value |
| --- | --- |
| Dictionary source | Webster's 1913 (A–Z), from [karthikramx/snippable-dictionary](https://github.com/karthikramx/snippable-dictionary/tree/main/Dictionary-in-csv) + local A section |
| Dictionary entries | 104,052 headwords (164,648 senses) |
| Seed vocabulary | LLaMA-3 BPE (`ggml-vocab-llama-bpe.gguf`) |
| Seed size | 128,256 tokens |
| Training corpus | balanced sample spanning all 26 initial letters (A–Z) |
| Corpus size | ~25,095 words |
| Target vocab size | 3,000 |
| Min pair frequency | 3 |

## 2. Measured outcome

| Metric | Value |
| --- | --- |
| BPE merges learned | 2,920 |
| Total trained vocabulary | 3,000 tokens |
| **New tokens** (not in the 128K seed) | **579** |
| — whole-word tokens | 187 |
| — **defined from Webster's** | **52** |
| — flagged `needs_definition` | 135 |
| — subword fragments (not dictionary words) | 392 |

### Seed-growth trajectory

The grow-seed loop folds each round's new tokens back into the seed until the
corpus yields nothing new (convergence).

| Round | Seed before | New found | Seed after | Net added |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 128,256 | 59 | 128,315 | +59 |
| 2 | 128,315 | 0 | 128,315 | +0 |

**Result:** seed grew 128,256 → 128,315 (+59), converged after 2 rounds.

## 3. Defined new words

All 52 new whole-word tokens that resolved to a real Webster's 1913
definition, sorted alphabetically. Definitions are truncated for the table; the
full text is in the source dictionary.

| # | Word | Part of speech | Definition (Webster's 1913) |
| ---: | --- | --- | --- |
| 1 | **brownish** | a. | Somewhat brown. |
| 2 | **Capable** | a. | Possessing ability, qualification, or susceptibility; having capacity; of sufficient size… |
| 3 | **Consist** | v. i. | To stand firm; to be in a fixed or permanent state, as a body composed of parts in union o… |
| 4 | **Consisting** | p. pr. & vb. n. | of Consist |
| 5 | **crystalline** | a. | Consisting, or made, of crystal. |
| 6 | **destitute** | a. | Forsaken; not having in possession (something necessary, or desirable); deficient; lacking… |
| 7 | **fasten** | a. | To fix firmly; to make fast; to secure, as by a knot, lock, bolt, etc.; as, to fasten a ch… |
| 8 | **Hindoos** | pl. | of Hindu |
| 9 | **inhabitant** | n. | One who dwells or resides permanently in a place, as distinguished from a transient lodger… |
| 10 | **Jant** | v. i. | See Jaunt. |
| 11 | **Jaunt** | v. i. | To ramble here and there; to stroll; to make an excursion. |
| 12 | **Keck** | v. i. | To heave or to retch, as in an effort to vomit. |
| 13 | **Keel** | v. t. & i. | To cool; to skim or stir. |
| 14 | **Kneel** | v. i. | To bend the knee; to fall or rest on the knees; -- sometimes with down. |
| 15 | **magnes** | n. | Magnet. |
| 16 | **metameric** | a. | Having the same elements united in the same proportion by weight, and with the same molecu… |
| 17 | **mone** | n. | The moon. |
| 18 | **Nod** | v. i. | To bend or incline the upper part, with a quick motion; as, nodding plumes. |
| 19 | **obtuse** | superl. | Not pointed or acute; blunt; -- applied esp. to angles greater than a right angle, or cont… |
| 20 | **Oss** | n. | To prophesy; to presage. |
| 21 | **Overt** | a. | Open to view; public; apparent; manifest. |
| 22 | **Pertaining** | p. pr. & vb. n. | of Pertain |
| 23 | **Pteropod** | n. | One of the Pteropoda. |
| 24 | **Quack** | v. i. | To utter a sound like the cry of a duck. |
| 25 | **Quas** | n. | A kind of beer. Same as Quass. |
| 26 | **Quilt** | n. | Anything that is quilted; esp., a quilted bed cover, or a skirt worn by women; any cover o… |
| 27 | **Quin** | n. | A European scallop (Pecten opercularis), used as food. |
| 28 | **reddish** | a. | Somewhat red; moderately red. |
| 29 | **Relating** | p. pr. & vb. n. | of Relate |
| 30 | **Resembling** | p. pr. & vb. n. | of Resemble |
| 31 | **Romish** | a. | Belonging or relating to Rome, or to the Roman Catholic Church; -- frequently used in a di… |
| 32 | **shrub** | n. | A liquor composed of vegetable acid, especially lemon juice, and sugar, with spirit to pre… |
| 33 | **Sis** | n. | A colloquial abbreviation of Sister. |
| 34 | **Somewhat** | n. | More or less; a certain quantity or degree; a part, more or less; something. |
| 35 | **Tending** | p. pr. & vb. n. | of Tend |
| 36 | **Whisk** | n. | A game at cards; whist. |
| 37 | **Xylograph** | n. | An engraving on wood, or the impression from such an engraving; a print by xylography. |
| 38 | **Yacht** | n. | A light and elegantly furnished vessel, used either for private parties of pleasure, or as… |
| 39 | **Yarr** | v. i. | To growl or snarl as a dog. |
| 40 | **Yaw** | v. i. | To rise in blisters, breaking in white froth, as cane juice in the clarifiers in sugar wor… |
| 41 | **Yawl** | n. | A small ship's boat, usually rowed by four or six oars. |
| 42 | **Yean** | v. t. & i. | To bring forth young, as a goat or a sheep; to ean. |
| 43 | **Yearn** | v. t. | To pain; to grieve; to vex. |
| 44 | **yellowish** | a. | Somewhat yellow; as, amber is of a yellowish color. |
| 45 | **Yester** | a. | Last; last past; next before; of or pertaining to yesterday. |
| 46 | **Yestern** | a. | Of or pertaining to yesterday; relating to the day last past. |
| 47 | **Yoke** | n. | A bar or frame of wood by which two oxen are joined at the heads or necks for working toge… |
| 48 | **Zany** | n. | A merry-andrew; a buffoon. |
| 49 | **Zeal** | n. | Passionate ardor in the pursuit of anything; eagerness in favor of a person or cause; arde… |
| 50 | **Zealot** | n. | One who is zealous; one who engages warmly in any cause, and pursues his object with earne… |
| 51 | **Zenith** | n. | That point in the visible celestial hemisphere which is vertical to the spectator; the poi… |
| 52 | **Zircon** | n. | A mineral occurring in tetragonal crystals, usually of a brown or gray color. It consists… |

## 4. Sample of undefined new whole-words

Of the 187 new whole-word tokens, 135 were
`needs_definition` — either intermediate BPE fragments that look word-like, or
word forms not present as headwords in the dictionary. A sample:

| Word | Note |
| --- | --- |
| Xyl | not a Webster's 1913 headword / BPE-intermediate |
| produc | not a Webster's 1913 headword / BPE-intermediate |
| Xanth | not a Webster's 1913 headword / BPE-intermediate |
| betw | not a Webster's 1913 headword / BPE-intermediate |
| sometim | not a Webster's 1913 headword / BPE-intermediate |
| giv | not a Webster's 1913 headword / BPE-intermediate |
| Xiph | not a Webster's 1913 headword / BPE-intermediate |
| xyl | not a Webster's 1913 headword / BPE-intermediate |
| someth | not a Webster's 1913 headword / BPE-intermediate |
| diseas | not a Webster's 1913 headword / BPE-intermediate |
| leav | not a Webster's 1913 headword / BPE-intermediate |
| specif | not a Webster's 1913 headword / BPE-intermediate |
| publ | not a Webster's 1913 headword / BPE-intermediate |
| piec | not a Webster's 1913 headword / BPE-intermediate |
| measur | not a Webster's 1913 headword / BPE-intermediate |
| Zoanth | not a Webster's 1913 headword / BPE-intermediate |
| Zant | not a Webster's 1913 headword / BPE-intermediate |
| Yach | not a Webster's 1913 headword / BPE-intermediate |
| knowled | not a Webster's 1913 headword / BPE-intermediate |
| extens | not a Webster's 1913 headword / BPE-intermediate |

## 5. What this demonstrates

- The pipeline **grows a real vocabulary** on top of the 128K LLaMA-3 seed and
  measures the growth (it does not merely assert it).
- With the full A–Z dictionary in place, new words are **defined for real**
  across the whole alphabet (e.g. *Capable, Jaunt, Kneel, Overt, Pteropod,
  Quack, Xylograph, Yacht, Zenith, Zealot, Zany*) — coverage that the earlier
  A-only dictionary could not provide.
- It does **not** fabricate meanings: unmatched words are flagged, and subword
  fragments are excluded from definition lookup.

As documented in `tools/ai/VOCABULARY_GROWTH.md`, producing a *usable* model
from a grown vocabulary still requires model (re)training; this pipeline
produces the vocabulary, merges, and definitions — the first stage of growth.
