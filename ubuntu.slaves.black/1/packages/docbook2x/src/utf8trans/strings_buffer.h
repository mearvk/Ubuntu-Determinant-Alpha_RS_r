/*
 * strings_buffer.h
 *
 * This module implements a packed storage area for
 * null-terminated constant strings.  It is efficient for 
 * making tables of many strings of small length.
 * In utf8trans, we use this for the strings
 * in the Unicode translation table.
 * 
 * Initially, we allocate a large buffer.  As more
 * and more strings are stored, they fill up
 * the buffer, and when the buffer is (nearly) full,
 * new buffers are allocated automatically to store
 * new strings.
 */

#ifndef STRINGS_BUFFER_H
#define STRINGS_BUFFER_H

#include <stdlib.h>

struct strings_section
{
    size_t cur_size;
    size_t size;
    char *cur;
    char *start;
    struct strings_section *next;
};

typedef struct strings_section *strings_buffer_t;

/*
 * Makes a strings buffer.  size is the initial
 * buffer size in bytes.
 */
strings_buffer_t strings_buffer_new(size_t size);

/*
 * Deallocates a strings buffer.  The strings
 * stored inside are all destroyed at once.
 */
void strings_buffer_delete(strings_buffer_t ss);

/*
 * Copies the null-terminated string s into the strings 
 * buffer, and returns its address inside the buffer.
 */
char *strings_buffer_add(strings_buffer_t *ss, const char *s);

#endif  /* !defined(STRINGS_BUFFER_H) */
