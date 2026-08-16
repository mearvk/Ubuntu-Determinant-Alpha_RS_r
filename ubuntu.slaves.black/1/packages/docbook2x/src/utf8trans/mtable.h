/* 
 * mtable.h
 * 
 * This module implements a sparse multi-level array.
 * The indices of the array range from 0 to (2^n)-1, inclusive,
 * and the n bits used for the addressing can be split
 * into arbitrary groups of consecutive bits, 
 * one group representing each level of the table.
 * 
 * This module is used in utf8trans to store
 * the Unicode translation table, where the index
 * can get as high as (2^31)-1, but usually the table
 * stores only a few thousand entries scattered in blocks
 * in the bottom 64k addresses.
 *
 * Each entry in the multi-level array is assumed
 * to be of type void*.  If unassigned, the entry
 * is the null pointer.
 */

#ifndef MTABLE_H
#define MTABLE_H

typedef unsigned int mtable_key;
struct mtable {
    int *exponents;
    void *slots[1];
};
typedef struct mtable *mtable_t;

/* 
 * Makes a new sparse multi-level array.
 * 
 * exponents is a list of positive integers which
 * are the number of bits of addressing for each 
 * level of the table.  The list is terminated
 * by a single zero entry.  
 *
 * For example, for a 2^4 * 2^8 table (total 2^(4+8) entries), 
 *  set exponents = [ 4, 8, 0 ].
 *
 * The most significant bits are listed first.
 *
 * All entries are initially unassigned (that is, they are NULL).
 */
mtable_t mtable_new(int *exponents);

/*
 * Deallocates a multi-level array created by mtable_delete.
 */
void mtable_delete(mtable_t mtable);

/*
 * Extends the given multi-level array by adding
 * more bits of addressing.  The existing
 * entries in the array are given a prefix of zero
 * in the expanded address space.
 */
mtable_t mtable_extend(mtable_t mtab, int *exponents);

/*
 * Changes the entry at the given index to the given data
 * value.
 */
void mtable_set(mtable_t mtable, mtable_key key, void *data);

/*
 * Returns the entry at the given index.
 */
void *mtable_get(mtable_t mtable, mtable_key key);

#endif  /* !defined MTABLE_H */

