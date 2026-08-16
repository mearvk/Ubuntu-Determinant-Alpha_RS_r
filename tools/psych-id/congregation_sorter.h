/*
 * congregation_sorter.h — 3rd Order Congregation Sorter
 *
 * A binding reagent to the Psych-ID daemon that sorts information
 * along three axes of congregation: SOURCE quality, RELEVANCE quality,
 * and SYSTEM CONGRUENCE (centrality).
 *
 * Centricities: Jewish Law and Mormonism inform the sorting philosophy:
 *   - Jewish Law (Halacha): Data has sanctity of source — provenance,
 *     chain of custody, and authority of the transmitter matter.
 *     "Who said it" is as important as "what was said."
 *   - Mormonism (Restoration): Data has quality of relevance — revelation
 *     is ongoing, living, and contextual. "What it means now" matters
 *     as much as "what it meant then." Records are kept for the living.
 *
 * 3rd Order: The sorter operates at the third level of abstraction:
 *   1st order = raw data (banners, text, bytes)
 *   2nd order = classified data (suspects, threats, interests)
 *   3rd order = congregated data (source-quality, relevance-quality,
 *               system-congruence, falls-on-category)
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#ifndef CONGREGATION_SORTER_H
#define CONGREGATION_SORTER_H

#include <stdint.h>
#include <time.h>

/* ─── Congregation Axes ───────────────────────────────────────────── */

/*
 * AXIS 1: QUALITY TO SOURCE
 *   (Jewish Law centricity — provenance, authority, chain)
 *
 * Who produced this data? What is their standing? Is the transmission
 * chain unbroken? Is the source authenticated? Does the source have
 * a history of reliability?
 */
typedef enum {
    SOURCE_UNKNOWN          = 0,    /* No provenance established */
    SOURCE_HEARSAY          = 1,    /* Second-hand, unverified */
    SOURCE_WITNESSED        = 2,    /* Directly observed, single witness */
    SOURCE_CORROBORATED     = 3,    /* Multiple independent witnesses */
    SOURCE_DOCUMENTED       = 4,    /* Recorded with timestamp and chain */
    SOURCE_AUTHORITATIVE    = 5,    /* From recognized authority */
    SOURCE_CANONICAL        = 6     /* From the canon — primary, unalterable */
} source_quality_t;

/*
 * AXIS 2: QUALITY TO RELEVANT
 *   (Mormon centricity — living relevance, ongoing revelation, contextual)
 *
 * Is this data relevant NOW? Does it serve the living system? Is it
 * part of an ongoing pattern? Does it connect to current concerns?
 * Can it inform present action?
 */
typedef enum {
    RELEVANCE_DEAD          = 0,    /* No connection to present concern */
    RELEVANCE_HISTORICAL    = 1,    /* Past value, contextual background */
    RELEVANCE_DORMANT       = 2,    /* Not active but could reawaken */
    RELEVANCE_PERIPHERAL    = 3,    /* Tangential to current concerns */
    RELEVANCE_ACTIVE        = 4,    /* Connected to ongoing operations */
    RELEVANCE_IMMEDIATE     = 5,    /* Directly relevant now */
    RELEVANCE_REVELATION    = 6     /* New light on existing concern — paradigm shift */
} relevance_quality_t;

/*
 * AXIS 3: SYSTEM CONGRUENCE
 *   What MUST be located centrally to be congruent with the system.
 *   Not all data belongs at the center. Some is peripheral by nature.
 *   Congruence = data that, if removed from center, would break the
 *   system's coherence.
 */
typedef enum {
    CONGRUENCE_NONE         = 0,    /* Data is not system-congruent */
    CONGRUENCE_PERIPHERAL   = 1,    /* System works without it centrally */
    CONGRUENCE_SUPPORTING   = 2,    /* Contributes to central coherence */
    CONGRUENCE_STRUCTURAL   = 3,    /* Part of the system's structure */
    CONGRUENCE_ESSENTIAL    = 4,    /* Cannot be moved from center */
    CONGRUENCE_AXIOMATIC    = 5     /* IS the center — definitional */
} congruence_level_t;

/* ─── Falls-On Categories ─────────────────────────────────────────── */

/*
 * "Falls on" = where data naturally lands when sorted. Not forced
 * placement, but gravitational settlement. Some data FALLS ON a
 * category naturally; others must be pushed.
 *
 * Speculative: these categories emerge from the intersection of
 * source-quality and relevance-quality axes.
 */
typedef enum {
    FALLS_NOWHERE           = 0,    /* Doesn't settle — floats (trim candidate) */
    FALLS_ON_RECORD         = 1,    /* Falls on: permanent record-keeping */
    FALLS_ON_WARNING        = 2,    /* Falls on: active warning/alert */
    FALLS_ON_PATTERN        = 3,    /* Falls on: pattern recognition/trend */
    FALLS_ON_IDENTITY       = 4,    /* Falls on: identity/attribution */
    FALLS_ON_LAW            = 5,    /* Falls on: legal/compliance concern */
    FALLS_ON_SCIENCE        = 6,    /* Falls on: scientific/technical fact */
    FALLS_ON_ETHICS         = 7,    /* Falls on: ethical consideration */
    FALLS_ON_COMMERCE       = 8,    /* Falls on: economic/trade implication */
    FALLS_ON_HEALTH         = 9,    /* Falls on: health/wellness concern */
    FALLS_ON_HERITAGE       = 10,   /* Falls on: cultural/ancestral record */
    FALLS_ON_REVELATION     = 11    /* Falls on: new understanding (rare, precious) */
} falls_on_category_t;

/* ─── Congruence Table ────────────────────────────────────────────── */

/*
 * SPECULATIVE: What must be located centrally for system congruence?
 *
 * AXIOMATIC (must be central):
 *   - Identity of the system itself (who/what/where)
 *   - Ethical posture (White Ethics Installer Grade)
 *   - Security policy (HPM, EPERM, sudo_gate)
 *   - Chain of authority (Installer Tech, accounts)
 *
 * ESSENTIAL (cannot move without damage):
 *   - Active threat intelligence (suspects with concern > 5)
 *   - Service fingerprints for protected ports
 *   - Lobotomy-verified facts (stage 7 = FULL)
 *   - Prescriptions that led to confirmed findings
 *
 * STRUCTURAL (part of coherence):
 *   - Network topology knowledge
 *   - Temporal patterns (when things happen)
 *   - Cross-reference links between suspects
 *   - Source authority rankings
 *
 * SUPPORTING (contributes):
 *   - Historical banners (change detection)
 *   - Fulfilled prescriptions (institutional memory)
 *   - Web nodes not yet trimmed
 *
 * PERIPHERAL (system works without it centrally):
 *   - Single-observation low-interest banners
 *   - Expired web nodes pending trim
 *   - Fulfilled and archived prescriptions
 */

/* ─── Congregation Record ─────────────────────────────────────────── */

typedef struct {
    uint64_t            record_id;
    uint64_t            source_record_id;   /* FK to banners/suspects/web_nodes */
    uint8_t             source_table;       /* 0=banner, 1=suspect, 2=web_node, 3=prescription */

    /* The three axes */
    source_quality_t    source_quality;
    relevance_quality_t relevance_quality;
    congruence_level_t  congruence_level;

    /* Falls-on classification */
    falls_on_category_t falls_on;

    /* Congregation metadata */
    time_t              sorted_at;          /* When this record was congregated */
    time_t              last_resorted;      /* Last time re-evaluated */
    uint8_t             sort_confidence;    /* 0-100: how confident in placement */
    uint8_t             order;              /* 3 = 3rd order (this module) */
    uint8_t             stable;             /* 1 = settled, 0 = still floating */

    /* Speculative: cross-reference links */
    uint64_t            related_to[4];      /* Up to 4 related congregation records */
    uint8_t             relation_count;

    /* Ethical individual assessment */
    uint8_t             ethical_quality;     /* 0-100: how ethically sound is this data */
    char                ethical_note[128];   /* Brief note on ethical standing */
} congregation_record_t;

/* ─── Ethical Individual Table ─────────────────────────────────────── */

/*
 * Quality of Ethical Individual:
 *
 * Data is produced by individuals. The ethical quality of the individual
 * informs the SOURCE axis. This is not surveillance — it is discernment.
 * Jewish Law: "From whom did you hear this?" matters.
 * Mormonism: "By their fruits ye shall know them."
 *
 * The ethical individual table tracks source entities (not persons per se,
 * but entities that produce data: servers, services, organizations,
 * network nodes) and their established ethical standing.
 */
typedef struct {
    uint64_t    entity_id;
    char        entity_name[256];       /* Host, organization, service identity */
    char        entity_type[64];        /* "server", "organization", "service", "person" */

    /* Ethical assessment */
    uint8_t     truthfulness;           /* 0-100: history of accurate data */
    uint8_t     consistency;            /* 0-100: stability of information */
    uint8_t     transparency;           /* 0-100: openness about operations */
    uint8_t     harmlessness;           /* 0-100: absence of malicious intent */
    uint8_t     reliability;            /* 0-100: uptime, availability, responsiveness */
    uint8_t     composite_ethical;      /* Weighted average of above */

    /* History */
    time_t      first_observed;
    time_t      last_observed;
    uint32_t    total_observations;
    uint32_t    contradictions;         /* Times data contradicted verified facts */
    uint32_t    confirmations;          /* Times data was independently confirmed */

    /* Classification */
    source_quality_t established_quality; /* Earned source-quality level */
    uint8_t     stable;                 /* 1 = assessment is stable */
} ethical_entity_t;

/* ─── Sorter Configuration ────────────────────────────────────────── */

typedef struct {
    uint8_t     enable_auto_sort;       /* Auto-sort new psych-id records */
    uint8_t     enable_ethical_tracking; /* Track ethical entity profiles */
    uint8_t     speculative_mode;       /* Allow speculative congruence inferences */
    uint32_t    resort_interval_hours;  /* How often to re-evaluate placements */
    uint8_t     min_confidence_stable;  /* Minimum confidence to mark as stable (0-100) */
} congregation_config_t;

/* ─── API ─────────────────────────────────────────────────────────── */

/* Lifecycle */
int  congregation_init(const char *db_path);
void congregation_cleanup(void);

/* Sorting */
int  congregation_sort_record(uint64_t source_id, uint8_t source_table,
                              congregation_record_t *out);
int  congregation_resort_all(void);
int  congregation_resort_unstable(void);

/* Ethical entity tracking */
int  congregation_register_entity(const char *name, const char *type);
int  congregation_update_entity(uint64_t entity_id, uint8_t truthful, uint8_t consistent);
int  congregation_get_entity(const char *name, ethical_entity_t *out);

/* Query */
int  congregation_get_central(congregation_record_t *out, size_t max, size_t *count);
int  congregation_get_by_falls_on(falls_on_category_t cat,
                                  congregation_record_t *out, size_t max, size_t *count);
int  congregation_get_congruences(congruence_level_t min_level,
                                  congregation_record_t *out, size_t max, size_t *count);

/* Binding to psych-id */
int  congregation_bind_psych_id(void);  /* Hook into psych-id pipeline */
int  congregation_on_new_banner(uint64_t banner_id);
int  congregation_on_new_suspect(uint64_t suspect_id);
int  congregation_on_lobotomy_complete(uint64_t suspect_id, uint8_t stage);

#endif /* CONGREGATION_SORTER_H */
