/*
 * congregation_sorter.c — 3rd Order Congregation Sorter
 *
 * Binding reagent to Psych-ID. Sorts all information through three
 * axes of congregation derived from the centricities of Jewish Law
 * (source quality, provenance, authority of transmitter) and Mormonism
 * (relevance quality, living revelation, records for the living).
 *
 * 3rd Order: operates above raw data (1st) and classification (2nd),
 * at the level of congregational meaning: what belongs together, what
 * belongs centrally, what falls naturally on what category, and what
 * is congruent with the system's self.
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <sqlite3.h>

#include "psych_id.h"
#include "congregation_sorter.h"

/* ─── Globals ─────────────────────────────────────────────────────── */

static sqlite3              *g_cdb = NULL;     /* Congregation database handle */
static pthread_mutex_t       g_cdb_mutex = PTHREAD_MUTEX_INITIALIZER;
static congregation_config_t g_cconfig;
static int                   g_bound = 0;      /* 1 = bound to psych-id */

/* ─── Internal: Database ──────────────────────────────────────────── */

static int cdb_create_schema(void)
{
    const char *schema[] = {
        /* Main congregation table */
        "CREATE TABLE IF NOT EXISTS congregation ("
        "  record_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  source_record_id INTEGER NOT NULL,"
        "  source_table INTEGER NOT NULL,"
        "  source_quality INTEGER DEFAULT 0,"
        "  relevance_quality INTEGER DEFAULT 0,"
        "  congruence_level INTEGER DEFAULT 0,"
        "  falls_on INTEGER DEFAULT 0,"
        "  sorted_at INTEGER,"
        "  last_resorted INTEGER,"
        "  sort_confidence INTEGER DEFAULT 50,"
        "  sort_order INTEGER DEFAULT 3,"
        "  stable INTEGER DEFAULT 0,"
        "  related_0 INTEGER DEFAULT 0,"
        "  related_1 INTEGER DEFAULT 0,"
        "  related_2 INTEGER DEFAULT 0,"
        "  related_3 INTEGER DEFAULT 0,"
        "  relation_count INTEGER DEFAULT 0,"
        "  ethical_quality INTEGER DEFAULT 50,"
        "  ethical_note TEXT DEFAULT ''"
        ")",

        /* Ethical entity table */
        "CREATE TABLE IF NOT EXISTS ethical_entities ("
        "  entity_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  entity_name TEXT NOT NULL UNIQUE,"
        "  entity_type TEXT DEFAULT 'server',"
        "  truthfulness INTEGER DEFAULT 50,"
        "  consistency INTEGER DEFAULT 50,"
        "  transparency INTEGER DEFAULT 50,"
        "  harmlessness INTEGER DEFAULT 80,"
        "  reliability INTEGER DEFAULT 50,"
        "  composite_ethical INTEGER DEFAULT 50,"
        "  first_observed INTEGER,"
        "  last_observed INTEGER,"
        "  total_observations INTEGER DEFAULT 0,"
        "  contradictions INTEGER DEFAULT 0,"
        "  confirmations INTEGER DEFAULT 0,"
        "  established_quality INTEGER DEFAULT 0,"
        "  stable INTEGER DEFAULT 0"
        ")",

        /* Congruence log: what decisions were made about centrality */
        "CREATE TABLE IF NOT EXISTS congruence_log ("
        "  log_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  congregation_id INTEGER,"
        "  old_level INTEGER,"
        "  new_level INTEGER,"
        "  reason TEXT,"
        "  decided_at INTEGER,"
        "  FOREIGN KEY (congregation_id) REFERENCES congregation(record_id)"
        ")",

        /* Indexes */
        "CREATE INDEX IF NOT EXISTS idx_cong_source ON congregation(source_record_id, source_table)",
        "CREATE INDEX IF NOT EXISTS idx_cong_congruence ON congregation(congruence_level)",
        "CREATE INDEX IF NOT EXISTS idx_cong_falls ON congregation(falls_on)",
        "CREATE INDEX IF NOT EXISTS idx_cong_stable ON congregation(stable)",
        "CREATE INDEX IF NOT EXISTS idx_entity_name ON ethical_entities(entity_name)",
        "CREATE INDEX IF NOT EXISTS idx_entity_quality ON ethical_entities(established_quality)",
        NULL
    };

    for (int i = 0; schema[i] != NULL; i++) {
        char *err = NULL;
        if (sqlite3_exec(g_cdb, schema[i], NULL, NULL, &err) != SQLITE_OK) {
            fprintf(stderr, "congregation: schema error: %s\n", err);
            sqlite3_free(err);
            return -1;
        }
    }
    return 0;
}

/* ─── Lifecycle ───────────────────────────────────────────────────── */

int congregation_init(const char *db_path)
{
    const char *path = db_path ? db_path : PSYCH_ID_DB_PATH;

    /* Open same database as psych-id (shared) */
    int rc = sqlite3_open(path, &g_cdb);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "congregation: cannot open db: %s\n", sqlite3_errmsg(g_cdb));
        return -1;
    }

    sqlite3_exec(g_cdb, "PRAGMA journal_mode=WAL", NULL, NULL, NULL);
    sqlite3_exec(g_cdb, "PRAGMA synchronous=NORMAL", NULL, NULL, NULL);

    if (cdb_create_schema() != 0)
        return -1;

    /* Defaults */
    g_cconfig.enable_auto_sort = 1;
    g_cconfig.enable_ethical_tracking = 1;
    g_cconfig.speculative_mode = 1;
    g_cconfig.resort_interval_hours = 24;
    g_cconfig.min_confidence_stable = 75;

    return 0;
}

void congregation_cleanup(void)
{
    if (g_cdb) {
        sqlite3_close(g_cdb);
        g_cdb = NULL;
    }
    g_bound = 0;
}

/* ─── Sorting Engine ──────────────────────────────────────────────── */

/*
 * infer_source_quality():
 *   Jewish Law centricity — assess provenance.
 *   "Who said it?" "Was it witnessed?" "By how many?"
 *   "Is there a chain of transmission?"
 */
static source_quality_t infer_source_quality(uint64_t source_id, uint8_t table)
{
    if (!g_cdb) return SOURCE_UNKNOWN;

    sqlite3_stmt *stmt = NULL;
    source_quality_t quality = SOURCE_UNKNOWN;

    if (table == 0) {  /* Banner */
        const char *sql = "SELECT seen_count, confidence, service_name "
                          "FROM banners WHERE record_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int seen = sqlite3_column_int(stmt, 0);
                int confidence = sqlite3_column_int(stmt, 1);
                const char *svc = (const char *)sqlite3_column_text(stmt, 2);

                if (seen >= 10 && confidence > 80 && svc && svc[0])
                    quality = SOURCE_DOCUMENTED;     /* Repeated, identified, recorded */
                else if (seen >= 3 && confidence > 60)
                    quality = SOURCE_CORROBORATED;   /* Multiple observations */
                else if (seen >= 2)
                    quality = SOURCE_WITNESSED;      /* Directly observed */
                else if (svc && svc[0])
                    quality = SOURCE_HEARSAY;        /* Single pass, has name */
                else
                    quality = SOURCE_UNKNOWN;        /* Single pass, no name */
            }
            sqlite3_finalize(stmt);
        }
    } else if (table == 1) {  /* Suspect */
        const char *sql = "SELECT total_observations, lobotomy_applied "
                          "FROM suspects WHERE suspect_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int obs = sqlite3_column_int(stmt, 0);
                int lob = sqlite3_column_int(stmt, 1);

                if (lob >= 7)
                    quality = SOURCE_CANONICAL;      /* Fully lobotomized = verified canon */
                else if (lob >= 5 && obs >= 5)
                    quality = SOURCE_AUTHORITATIVE;  /* Science + law verified */
                else if (obs >= 3)
                    quality = SOURCE_CORROBORATED;
                else
                    quality = SOURCE_WITNESSED;
            }
            sqlite3_finalize(stmt);
        }
    }

    return quality;
}

/*
 * infer_relevance_quality():
 *   Mormon centricity — assess living relevance.
 *   "Is this data alive now?" "Does it serve the living system?"
 *   "Is it part of an ongoing revelation?"
 */
static relevance_quality_t infer_relevance_quality(uint64_t source_id, uint8_t table)
{
    if (!g_cdb) return RELEVANCE_DEAD;

    sqlite3_stmt *stmt = NULL;
    relevance_quality_t quality = RELEVANCE_DEAD;
    time_t now = time(NULL);

    if (table == 0) {  /* Banner */
        const char *sql = "SELECT last_seen, interest_score, threat_score "
                          "FROM banners WHERE record_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                time_t last = sqlite3_column_int64(stmt, 0);
                int interest = sqlite3_column_int(stmt, 1);
                int threat = sqlite3_column_int(stmt, 2);
                time_t age = now - last;

                if (threat > 70 && age < 3600)
                    quality = RELEVANCE_REVELATION;  /* High threat, just seen = new light */
                else if (interest > 60 && age < 86400)
                    quality = RELEVANCE_IMMEDIATE;   /* High interest, today */
                else if (age < 86400 * 7)
                    quality = RELEVANCE_ACTIVE;      /* This week */
                else if (age < 86400 * 30)
                    quality = RELEVANCE_PERIPHERAL;  /* This month */
                else if (age < 86400 * 90)
                    quality = RELEVANCE_DORMANT;     /* Sleeping */
                else if (age < 86400 * 365)
                    quality = RELEVANCE_HISTORICAL;  /* Archival */
                else
                    quality = RELEVANCE_DEAD;        /* Ancient */
            }
            sqlite3_finalize(stmt);
        }
    } else if (table == 1) {  /* Suspect */
        const char *sql = "SELECT last_activity, concern_level "
                          "FROM suspects WHERE suspect_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                time_t last = sqlite3_column_int64(stmt, 0);
                int concern = sqlite3_column_int(stmt, 1);
                time_t age = now - last;

                if (concern >= 8 && age < 86400)
                    quality = RELEVANCE_REVELATION;
                else if (concern >= 5)
                    quality = RELEVANCE_IMMEDIATE;
                else if (age < 86400 * 7)
                    quality = RELEVANCE_ACTIVE;
                else if (age < 86400 * 30)
                    quality = RELEVANCE_PERIPHERAL;
                else
                    quality = RELEVANCE_DORMANT;
            }
            sqlite3_finalize(stmt);
        }
    }

    return quality;
}

/*
 * infer_congruence_level():
 *   What MUST be centrally located for system coherence?
 *   Speculative placement based on source+relevance axes.
 */
static congruence_level_t infer_congruence(source_quality_t src, relevance_quality_t rel)
{
    /* Canonical source + immediate/revelation relevance = AXIOMATIC */
    if (src >= SOURCE_CANONICAL && rel >= RELEVANCE_IMMEDIATE)
        return CONGRUENCE_AXIOMATIC;

    /* Authoritative source + active relevance = ESSENTIAL */
    if (src >= SOURCE_AUTHORITATIVE && rel >= RELEVANCE_ACTIVE)
        return CONGRUENCE_ESSENTIAL;

    /* Documented/corroborated + active = STRUCTURAL */
    if (src >= SOURCE_CORROBORATED && rel >= RELEVANCE_ACTIVE)
        return CONGRUENCE_STRUCTURAL;

    /* Witnessed + peripheral or better = SUPPORTING */
    if (src >= SOURCE_WITNESSED && rel >= RELEVANCE_PERIPHERAL)
        return CONGRUENCE_SUPPORTING;

    /* Everything else is peripheral */
    if (rel >= RELEVANCE_DORMANT)
        return CONGRUENCE_PERIPHERAL;

    return CONGRUENCE_NONE;
}

/*
 * infer_falls_on():
 *   Speculative: where does data NATURALLY settle?
 *   Based on content analysis of the source record.
 */
static falls_on_category_t infer_falls_on(uint64_t source_id, uint8_t table,
                                           source_quality_t src, relevance_quality_t rel)
{
    if (!g_cdb) return FALLS_NOWHERE;

    /* If source is canonical and relevance is revelation = REVELATION */
    if (src >= SOURCE_CANONICAL && rel >= RELEVANCE_REVELATION)
        return FALLS_ON_REVELATION;

    if (table == 0) {  /* Banner: falls based on port/service */
        sqlite3_stmt *stmt;
        const char *sql = "SELECT target_port, threat_score, service_name FROM banners WHERE record_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int port = sqlite3_column_int(stmt, 0);
                int threat = sqlite3_column_int(stmt, 1);
                /* const char *svc = (const char *)sqlite3_column_text(stmt, 2); */

                sqlite3_finalize(stmt);

                if (threat >= 50) return FALLS_ON_WARNING;
                if (port == 22 || port == 443) return FALLS_ON_IDENTITY;
                if (port == 80 || port == 8080) return FALLS_ON_PATTERN;
                if (port == 21 || port == 20) return FALLS_ON_RECORD;
                return FALLS_ON_PATTERN;
            }
            sqlite3_finalize(stmt);
        }
    } else if (table == 1) {  /* Suspect: falls based on concern and lobotomy */
        sqlite3_stmt *stmt;
        const char *sql = "SELECT concern_level, lobotomy_applied FROM suspects WHERE suspect_id=?";
        if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_int64(stmt, 1, source_id);
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int concern = sqlite3_column_int(stmt, 0);
                int lob = sqlite3_column_int(stmt, 1);

                sqlite3_finalize(stmt);

                if (concern >= 8) return FALLS_ON_WARNING;
                if (lob >= 4)  return FALLS_ON_LAW;       /* Law-verified = law category */
                if (lob >= 6)  return FALLS_ON_SCIENCE;   /* Science-verified */
                if (concern >= 5) return FALLS_ON_ETHICS;
                return FALLS_ON_RECORD;
            }
            sqlite3_finalize(stmt);
        }
    }

    return FALLS_NOWHERE;
}

/*
 * compute_ethical_quality():
 *   Assess the ethical standing of the data based on its source entity.
 */
static uint8_t compute_ethical_quality(uint64_t source_id, uint8_t table)
{
    if (!g_cdb) return 50;

    /* Find the entity associated with this source */
    const char *host_sql = (table == 0)
        ? "SELECT target_host FROM banners WHERE record_id=?"
        : "SELECT host FROM suspects WHERE suspect_id=?";

    sqlite3_stmt *stmt;
    char host[256] = {0};

    if (sqlite3_prepare_v2(g_cdb, host_sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, source_id);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            const char *h = (const char *)sqlite3_column_text(stmt, 0);
            if (h) strncpy(host, h, sizeof(host) - 1);
        }
        sqlite3_finalize(stmt);
    }

    if (!host[0]) return 50;  /* Unknown entity = neutral */

    /* Look up ethical entity */
    const char *entity_sql = "SELECT composite_ethical FROM ethical_entities WHERE entity_name=?";
    if (sqlite3_prepare_v2(g_cdb, entity_sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, host, -1, SQLITE_STATIC);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            uint8_t ethical = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
            return ethical;
        }
        sqlite3_finalize(stmt);
    }

    /* No entity record: create one */
    if (g_cconfig.enable_ethical_tracking) {
        congregation_register_entity(host, "server");
    }

    return 50;  /* New entity starts neutral */
}

/* ─── Public Sorting API ──────────────────────────────────────────── */

int congregation_sort_record(uint64_t source_id, uint8_t source_table,
                             congregation_record_t *out)
{
    if (!g_cdb || !out) return -1;

    memset(out, 0, sizeof(*out));
    out->source_record_id = source_id;
    out->source_table = source_table;
    out->order = 3;
    out->sorted_at = time(NULL);

    /* Infer the three axes */
    out->source_quality = infer_source_quality(source_id, source_table);
    out->relevance_quality = infer_relevance_quality(source_id, source_table);
    out->congruence_level = infer_congruence(out->source_quality, out->relevance_quality);

    /* Infer falls-on category */
    out->falls_on = infer_falls_on(source_id, source_table,
                                    out->source_quality, out->relevance_quality);

    /* Compute ethical quality */
    out->ethical_quality = compute_ethical_quality(source_id, source_table);

    /* Confidence: higher when both axes are strong */
    int confidence = 30;
    confidence += out->source_quality * 8;
    confidence += out->relevance_quality * 5;
    if (out->congruence_level >= CONGRUENCE_STRUCTURAL) confidence += 15;
    if (confidence > 100) confidence = 100;
    out->sort_confidence = confidence;

    /* Stability: mark stable if confidence exceeds threshold */
    out->stable = (confidence >= g_cconfig.min_confidence_stable) ? 1 : 0;

    /* Store in database */
    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *insert =
        "INSERT INTO congregation (source_record_id, source_table, source_quality, "
        "relevance_quality, congruence_level, falls_on, sorted_at, last_resorted, "
        "sort_confidence, sort_order, stable, ethical_quality, ethical_note) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 3, ?, ?, '')";

    if (sqlite3_prepare_v2(g_cdb, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, source_id);
        sqlite3_bind_int(stmt, 2, source_table);
        sqlite3_bind_int(stmt, 3, out->source_quality);
        sqlite3_bind_int(stmt, 4, out->relevance_quality);
        sqlite3_bind_int(stmt, 5, out->congruence_level);
        sqlite3_bind_int(stmt, 6, out->falls_on);
        sqlite3_bind_int64(stmt, 7, out->sorted_at);
        sqlite3_bind_int64(stmt, 8, out->sorted_at);
        sqlite3_bind_int(stmt, 9, out->sort_confidence);
        sqlite3_bind_int(stmt, 10, out->stable);
        sqlite3_bind_int(stmt, 11, out->ethical_quality);
        sqlite3_step(stmt);
        out->record_id = sqlite3_last_insert_rowid(g_cdb);
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_resort_all(void)
{
    if (!g_cdb) return -1;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id, source_record_id, source_table "
                      "FROM congregation ORDER BY record_id";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            uint64_t id = sqlite3_column_int64(stmt, 0);
            uint64_t src_id = sqlite3_column_int64(stmt, 1);
            uint8_t tbl = sqlite3_column_int(stmt, 2);

            source_quality_t sq = infer_source_quality(src_id, tbl);
            relevance_quality_t rq = infer_relevance_quality(src_id, tbl);
            congruence_level_t cl = infer_congruence(sq, rq);
            falls_on_category_t fo = infer_falls_on(src_id, tbl, sq, rq);

            char update[512];
            snprintf(update, sizeof(update),
                     "UPDATE congregation SET source_quality=%d, relevance_quality=%d, "
                     "congruence_level=%d, falls_on=%d, last_resorted=%lld "
                     "WHERE record_id=%lld",
                     sq, rq, cl, fo, (long long)time(NULL), (long long)id);
            sqlite3_exec(g_cdb, update, NULL, NULL, NULL);
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_resort_unstable(void)
{
    if (!g_cdb) return -1;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id, source_record_id, source_table "
                      "FROM congregation WHERE stable=0 ORDER BY sorted_at DESC LIMIT 100";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            uint64_t id = sqlite3_column_int64(stmt, 0);
            uint64_t src_id = sqlite3_column_int64(stmt, 1);
            uint8_t tbl = sqlite3_column_int(stmt, 2);

            source_quality_t sq = infer_source_quality(src_id, tbl);
            relevance_quality_t rq = infer_relevance_quality(src_id, tbl);
            congruence_level_t cl = infer_congruence(sq, rq);
            falls_on_category_t fo = infer_falls_on(src_id, tbl, sq, rq);
            uint8_t eq = compute_ethical_quality(src_id, tbl);

            int confidence = 30 + sq * 8 + rq * 5;
            if (cl >= CONGRUENCE_STRUCTURAL) confidence += 15;
            if (confidence > 100) confidence = 100;
            int stable = (confidence >= g_cconfig.min_confidence_stable) ? 1 : 0;

            char update[512];
            snprintf(update, sizeof(update),
                     "UPDATE congregation SET source_quality=%d, relevance_quality=%d, "
                     "congruence_level=%d, falls_on=%d, sort_confidence=%d, stable=%d, "
                     "ethical_quality=%d, last_resorted=%lld WHERE record_id=%lld",
                     sq, rq, cl, fo, confidence, stable, eq,
                     (long long)time(NULL), (long long)id);
            sqlite3_exec(g_cdb, update, NULL, NULL, NULL);
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

/* ─── Ethical Entity Tracking ─────────────────────────────────────── */

int congregation_register_entity(const char *name, const char *type)
{
    if (!g_cdb || !name) return -1;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *insert =
        "INSERT OR IGNORE INTO ethical_entities (entity_name, entity_type, "
        "first_observed, last_observed, total_observations) VALUES (?, ?, ?, ?, 1)";

    time_t now = time(NULL);
    if (sqlite3_prepare_v2(g_cdb, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 2, type ? type : "server", -1, SQLITE_STATIC);
        sqlite3_bind_int64(stmt, 3, now);
        sqlite3_bind_int64(stmt, 4, now);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_update_entity(uint64_t entity_id, uint8_t truthful, uint8_t consistent)
{
    if (!g_cdb) return -1;

    pthread_mutex_lock(&g_cdb_mutex);

    char sql[512];
    snprintf(sql, sizeof(sql),
             "UPDATE ethical_entities SET truthfulness=%u, consistency=%u, "
             "composite_ethical=(%u + %u + transparency + harmlessness + reliability) / 5, "
             "last_observed=%lld, total_observations=total_observations+1 "
             "WHERE entity_id=%lld",
             truthful, consistent, truthful, consistent,
             (long long)time(NULL), (long long)entity_id);
    sqlite3_exec(g_cdb, sql, NULL, NULL, NULL);

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_get_entity(const char *name, ethical_entity_t *out)
{
    if (!g_cdb || !name || !out) return -1;
    memset(out, 0, sizeof(*out));

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT entity_id, entity_name, entity_type, truthfulness, "
                      "consistency, transparency, harmlessness, reliability, composite_ethical, "
                      "first_observed, last_observed, total_observations, contradictions, "
                      "confirmations, established_quality, stable "
                      "FROM ethical_entities WHERE entity_name=?";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_STATIC);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            out->entity_id = sqlite3_column_int64(stmt, 0);
            strncpy(out->entity_name, (const char *)sqlite3_column_text(stmt, 1),
                    sizeof(out->entity_name) - 1);
            strncpy(out->entity_type, (const char *)sqlite3_column_text(stmt, 2),
                    sizeof(out->entity_type) - 1);
            out->truthfulness = sqlite3_column_int(stmt, 3);
            out->consistency = sqlite3_column_int(stmt, 4);
            out->transparency = sqlite3_column_int(stmt, 5);
            out->harmlessness = sqlite3_column_int(stmt, 6);
            out->reliability = sqlite3_column_int(stmt, 7);
            out->composite_ethical = sqlite3_column_int(stmt, 8);
            out->first_observed = sqlite3_column_int64(stmt, 9);
            out->last_observed = sqlite3_column_int64(stmt, 10);
            out->total_observations = sqlite3_column_int(stmt, 11);
            out->contradictions = sqlite3_column_int(stmt, 12);
            out->confirmations = sqlite3_column_int(stmt, 13);
            out->established_quality = sqlite3_column_int(stmt, 14);
            out->stable = sqlite3_column_int(stmt, 15);
            sqlite3_finalize(stmt);
            pthread_mutex_unlock(&g_cdb_mutex);
            return 0;
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return -1;
}

/* ─── Query ───────────────────────────────────────────────────────── */

int congregation_get_central(congregation_record_t *out, size_t max, size_t *count)
{
    if (!g_cdb || !out || !count) return -1;
    *count = 0;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id, source_record_id, source_table, "
                      "source_quality, relevance_quality, congruence_level, "
                      "falls_on, sort_confidence, stable, ethical_quality "
                      "FROM congregation WHERE congruence_level >= 4 "
                      "ORDER BY congruence_level DESC, sort_confidence DESC LIMIT ?";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, max);
        while (sqlite3_step(stmt) == SQLITE_ROW && *count < max) {
            congregation_record_t *r = &out[*count];
            memset(r, 0, sizeof(*r));
            r->record_id = sqlite3_column_int64(stmt, 0);
            r->source_record_id = sqlite3_column_int64(stmt, 1);
            r->source_table = sqlite3_column_int(stmt, 2);
            r->source_quality = sqlite3_column_int(stmt, 3);
            r->relevance_quality = sqlite3_column_int(stmt, 4);
            r->congruence_level = sqlite3_column_int(stmt, 5);
            r->falls_on = sqlite3_column_int(stmt, 6);
            r->sort_confidence = sqlite3_column_int(stmt, 7);
            r->stable = sqlite3_column_int(stmt, 8);
            r->ethical_quality = sqlite3_column_int(stmt, 9);
            r->order = 3;
            (*count)++;
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_get_by_falls_on(falls_on_category_t cat,
                                 congregation_record_t *out, size_t max, size_t *count)
{
    if (!g_cdb || !out || !count) return -1;
    *count = 0;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id, source_record_id, source_table, "
                      "source_quality, relevance_quality, congruence_level, "
                      "falls_on, sort_confidence, stable, ethical_quality "
                      "FROM congregation WHERE falls_on=? "
                      "ORDER BY sort_confidence DESC LIMIT ?";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, cat);
        sqlite3_bind_int(stmt, 2, max);
        while (sqlite3_step(stmt) == SQLITE_ROW && *count < max) {
            congregation_record_t *r = &out[*count];
            memset(r, 0, sizeof(*r));
            r->record_id = sqlite3_column_int64(stmt, 0);
            r->source_record_id = sqlite3_column_int64(stmt, 1);
            r->source_table = sqlite3_column_int(stmt, 2);
            r->source_quality = sqlite3_column_int(stmt, 3);
            r->relevance_quality = sqlite3_column_int(stmt, 4);
            r->congruence_level = sqlite3_column_int(stmt, 5);
            r->falls_on = sqlite3_column_int(stmt, 6);
            r->sort_confidence = sqlite3_column_int(stmt, 7);
            r->stable = sqlite3_column_int(stmt, 8);
            r->ethical_quality = sqlite3_column_int(stmt, 9);
            r->order = 3;
            (*count)++;
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

int congregation_get_congruences(congruence_level_t min_level,
                                 congregation_record_t *out, size_t max, size_t *count)
{
    if (!g_cdb || !out || !count) return -1;
    *count = 0;

    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id, source_record_id, source_table, "
                      "source_quality, relevance_quality, congruence_level, "
                      "falls_on, sort_confidence, stable, ethical_quality "
                      "FROM congregation WHERE congruence_level >= ? "
                      "ORDER BY congruence_level DESC LIMIT ?";

    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, min_level);
        sqlite3_bind_int(stmt, 2, max);
        while (sqlite3_step(stmt) == SQLITE_ROW && *count < max) {
            congregation_record_t *r = &out[*count];
            memset(r, 0, sizeof(*r));
            r->record_id = sqlite3_column_int64(stmt, 0);
            r->source_record_id = sqlite3_column_int64(stmt, 1);
            r->source_table = sqlite3_column_int(stmt, 2);
            r->source_quality = sqlite3_column_int(stmt, 3);
            r->relevance_quality = sqlite3_column_int(stmt, 4);
            r->congruence_level = sqlite3_column_int(stmt, 5);
            r->falls_on = sqlite3_column_int(stmt, 6);
            r->sort_confidence = sqlite3_column_int(stmt, 7);
            r->stable = sqlite3_column_int(stmt, 8);
            r->ethical_quality = sqlite3_column_int(stmt, 9);
            r->order = 3;
            (*count)++;
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}

/* ─── Binding to Psych-ID ─────────────────────────────────────────── */

int congregation_bind_psych_id(void)
{
    if (g_bound) return 0;
    g_bound = 1;
    return 0;
}

int congregation_on_new_banner(uint64_t banner_id)
{
    if (!g_bound || !g_cconfig.enable_auto_sort) return 0;

    congregation_record_t rec;
    return congregation_sort_record(banner_id, 0, &rec);
}

int congregation_on_new_suspect(uint64_t suspect_id)
{
    if (!g_bound || !g_cconfig.enable_auto_sort) return 0;

    congregation_record_t rec;
    return congregation_sort_record(suspect_id, 1, &rec);
}

int congregation_on_lobotomy_complete(uint64_t suspect_id, uint8_t stage)
{
    if (!g_bound) return 0;

    /* When lobotomy completes, the source quality potentially increases.
     * Re-sort the congregation record. */
    pthread_mutex_lock(&g_cdb_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT record_id FROM congregation "
                      "WHERE source_record_id=? AND source_table=1";
    if (sqlite3_prepare_v2(g_cdb, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, suspect_id);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            uint64_t cong_id = sqlite3_column_int64(stmt, 0);
            sqlite3_finalize(stmt);
            pthread_mutex_unlock(&g_cdb_mutex);

            /* Re-sort */
            congregation_record_t rec;
            congregation_sort_record(suspect_id, 1, &rec);

            /* Log the congruence change */
            pthread_mutex_lock(&g_cdb_mutex);
            char log_sql[256];
            snprintf(log_sql, sizeof(log_sql),
                     "INSERT INTO congruence_log (congregation_id, new_level, reason, decided_at) "
                     "VALUES (%lld, %d, 'lobotomy stage %u complete', %lld)",
                     (long long)cong_id, rec.congruence_level, stage, (long long)time(NULL));
            sqlite3_exec(g_cdb, log_sql, NULL, NULL, NULL);
            pthread_mutex_unlock(&g_cdb_mutex);
            return 0;
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_cdb_mutex);
    return 0;
}
