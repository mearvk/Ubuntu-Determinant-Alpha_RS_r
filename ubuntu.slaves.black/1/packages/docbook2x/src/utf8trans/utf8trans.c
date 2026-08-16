/* vim: sta et sw=4
 */

/*
 * $Id: utf8trans.c,v 1.12 2006/04/13 01:00:01 stevecheng Exp $
 *
 * (C) 2001 Steve Cheng <stevecheng@users.sourceforge.net>
 *
 * See ../COPYING for the copyright status of this software.
 *
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define _GNU_SOURCE     /* For getline */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "mtable.h"
#include "strings_buffer.h"

/* UCS-4 character */
typedef unsigned int CHAR;

#ifdef HAVE_GETOPT_H
#include <getopt.h>
#endif

#ifdef HAVE_GETOPT_LONG
/* Long-option specification */
struct option long_options[] =
{
    { "version", 0, 0, 'v' },
    { "help", 0, 0, 'h' },
    { "modify", 0, 0, 'm' },
    
    { 0, 0, 0, 0 }
};
#endif

const char *prog_name;
const char *charmap_filename = NULL;
mtable_t charmap_table;
static int charmap_table_exponents[] = { 8, 8, 8, 8, 0 };
strings_buffer_t charmap_strings;
int modify_in_place = 0;

int do_options(int argc, char *argv[]);
void print_version(void);
void print_usage();
void add_translation(CHAR codepoint, char *translation);
void parse_charmap(FILE *stream);
char *encode_utf8(CHAR codepoint);
void translate(FILE *in, FILE *out);

#ifndef HAVE_GETLINE
ssize_t getline(char **lineptr, size_t *n, FILE *stream);
#endif

int
main(int argc, char *argv[])
{
    FILE *charmap_f;
    int optind;
    
    prog_name = argv[0];
    optind = do_options(argc, argv);
    
    charmap_table = mtable_new(charmap_table_exponents);
    charmap_strings = strings_buffer_new(4096);
    
    /* Read translation spec */
    charmap_filename = argv[optind];
    charmap_f = fopen(charmap_filename, "r");
    if(!charmap_f) {
        fprintf(stderr, "%s:%s: %s\n", 
                prog_name,
                charmap_filename,
                strerror(errno));
        exit(1);
    }

    parse_charmap(charmap_f);

    fclose(charmap_f);

    optind++;
    
    if(!argv[optind]) {
        translate(stdin, stdout);
    }
    else {
        int i;
        FILE *f, *out;
        for(i = optind; argv[i]; i++) {
            out = stdout;

            f = fopen(argv[i], "r");
            if(!f) {
                fprintf(stderr, "%s:%s: %s\n",
                        prog_name,
                        argv[i],
                        strerror(errno));
                exit(1);
            }

#ifdef HAVE_UNISTD_H
            if(modify_in_place) {
                if(unlink(argv[i]) < 0) {
                    fprintf(stderr, "%s:%s: %s\n",
                            prog_name,
                            argv[i],
                            strerror(errno));
                    fclose(f);
                    continue;
                }
                    
                out = fopen(argv[i], "w");
                if(!out) {
                    fprintf(stderr, "%s:%s: %s\n",
                            prog_name,
                            argv[i],
                            strerror(errno));
                    fclose(f);
                    continue;
                }
            }
#endif
            
            translate(f, out);
            fclose(f);

            if(modify_in_place)
                fclose(out);
        }
    }

    mtable_delete(charmap_table);
    strings_buffer_delete(charmap_strings);

    return 0;
}

void
print_version(void)
{
    puts("utf8trans (part of docbook2X" 
#ifdef HAVE_CONFIG_H
    VERSION
#endif
        ")");

    puts("$Revision: 1.12 $ $Date: 2006/04/13 01:00:01 $");
    puts("<URL:http://docbook2x.sourceforge.net/>\n");
    
    puts("Copyright (C) 2000-2004 Steve Cheng\n"
         "This is free software; see the source for copying conditions.\n"
         "There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR\n"
         "A PARTICULAR PURPOSE.");
}

void
print_usage()
{
    printf("Usage: %s [options] CHARMAP [FILES...]\n", prog_name);
    puts("Transliterate UTF-8 characters according to a table.\n");

#ifdef HAVE_UNISTD_H
#ifdef HAVE_GETOPT_LONG
    puts("  -m, --modify            modify given files in-place\n"
         "  -v, --version           display version information and exit\n"
         "  -h, --help              display this usage information\n");
#else
    puts("  -m                      modify given files in-place\n"
         "  -v                      display version information and exit\n"
         "  -h                      display this usage information\n");
#endif
#endif

    puts("See utf8trans(1) for details on this program.\n");
}
    
int
do_options(int argc, char *argv[])
{
#ifdef HAVE_UNISTD_H    /* On a Unix, so have some version of getopt */
    int optc;

#ifdef HAVE_GETOPT_LONG
    while((optc = getopt_long(argc, argv, "vhm", 
                long_options, NULL)) != -1)
#else
    while((optc = getopt(argc, argv, "vhm")) != -1)
#endif  /* HAVE_GETOPT_LONG */
    {
        switch(optc) {

        /* --version */
        case 'v':
            print_version();
            exit(0);
            
        /* --help */
        case 'h':
            print_usage();
            exit(0);

        /* --modify */
        case 'm':
            modify_in_place = 1;
            break;

        case '?':
        default:
            exit(1);
        }
    }

    if(optind > argc-1) {
        fprintf(stderr, "%s: must specify charmap\n", prog_name);
        exit(1);
    }

    return optind;
    
#else   /* No getopt, so don't process any options.
           They are all trivial, so that justifies ignoring them. */

    if(argc < 2) {
        fprintf(stderr, "%s: must specify charmap\n", prog_name);
        exit(1);
    }
    
    return 1;

#endif  
}

void 
add_translation(CHAR codepoint, char *translation)
{
    char *s = strings_buffer_add(&charmap_strings, translation);
    mtable_set(charmap_table, codepoint, s);
}

char *
get_translation(CHAR codepoint)
{
    char *translation = mtable_get(charmap_table, codepoint);
    if(translation != NULL)
        return translation;
    else
        return encode_utf8(codepoint);
}

char *
encode_utf8(CHAR c)
{
    static char buf[7];
    char *p = buf;
    
    if(c < 0x80) {
        *p++ = c;
        *p++ = '\0';
    } else if(c < 0x800) {
        *p++ = 0xC0 | (c>>6);
        *p++ = 0x80 | (c & 0x3F);
        *p++ = '\0';
    } else if(c < 0x10000) {
        *p++ = 0xE0 | (c>>12);
        *p++ = 0x80 | ((c>>6) & 0x3F);
        *p++ = 0x80 | (c & 0x3F);
        *p++ = '\0';
    } else if (c < 0x200000) {
        *p++ = 0xF0 | (c>>18);
        *p++ = 0x80 | ((c>>12) & 0x3F);
        *p++ = 0x80 | ((c>>6) & 0x3F);
        *p++ = 0x80 | (c & 0x3F);
        *p++ = '\0';
    } else if (c < 0x4000000) {
        *p++ = 0xF8 | (c>>24);
        *p++ = 0x80 | ((c>>18) & 0x3F);
        *p++ = 0x80 | ((c>>12) & 0x3F);
        *p++ = 0x80 | ((c>>6) & 0x3F);
        *p++ = 0x80 | (c & 0x3F);
        *p++ = '\0';
    } else if (c < 0x80000000) {
        *p++ = 0xFC | (c>>30);
        *p++ = 0x80 | ((c>>24) & 0x3F);
        *p++ = 0x80 | ((c>>18) & 0x3F);
        *p++ = 0x80 | ((c>>12) & 0x3F);
        *p++ = 0x80 | ((c>>6) & 0x3F);
        *p++ = 0x80 | (c & 0x3F);
        *p++ = '\0';
    } else {
        /* Oops */
        abort();
    }
    
    return buf;
}

/* 0 to 9, a to f, A to F */
#define IS_HEXDIGIT(c) (((c) >= 48 && (c) <= 57) || \
                        ((c) >= 97 && (c) <= 102) || \
                        ((c) >= 65 && (c) <= 70))
#define IS_SPACE(c) ((c) == ' ' || (c) == '\t')

void parse_charmap(FILE *stream)
{
    char *buf = NULL;
    size_t bufsize = 0;
    char *p, *c, *t;
    int linecount = 0;

    CHAR codepoint;
    
    while(!feof(stream)) {
        linecount++;
        if(getline(&buf, &bufsize, stream) == -1) {
            if(!feof(stream)) {
                fprintf(stderr, "%s:%s: %s",
                        prog_name, charmap_filename, 
                        strerror(errno));
                exit(2);
            }
            goto nextline;
        }

        /* Chomp newline */
        p = buf + (strlen(buf)-1);
        if(*p == '\n') *p = '\0';

        /* Skip to codepoint */
        for(c = buf; *c && IS_SPACE(*c); c++);

        /* Skip empty lines and comment lines */
        if(*c == '\0' || *c == '#')
            goto nextline;

        t = NULL;

        /* Parse the codepoint (a number in hex) */
        for(p = c; *p; p++) {
            if(!IS_HEXDIGIT(*p)) {
                if(!IS_SPACE(*p)) {
                    fprintf(stderr, "%s:%s:%d: %s",
                            prog_name, charmap_filename, linecount,
                            "(parsing codepoint) invalid hex number\n");
                    goto nextline;
                }

                *p = '\0';
                
                if(sscanf(c, "%x", &codepoint) != 1) {
                    fprintf(stderr, "%s:%s:%d: %s",
                            prog_name, charmap_filename, linecount,
                            "(parsing codepoint) invalid hex number\n");
                    goto nextline;
                }

                t = ++p;
                break;
            }
        }

        if(t) {
            add_translation(codepoint, t);
        } else {
            /* No translation text */
            if(sscanf(c, "%x", &codepoint) != 1) {
                fprintf(stderr, "%s:%s:%d: %s",
                        prog_name, charmap_filename, linecount,
                        "(parsing codepoint) invalid hex number\n");
                goto nextline;
            }
            add_translation(codepoint, "");
        }
nextline: ;
    }

    if(buf)
        free(buf);
}

CHAR
read_utf8_char(FILE *stream)
{
    CHAR character;
    int b, n, i;

    b = fgetc(stream);
    if(b == EOF)
        return 0xFFFFFFFF;

    /* UTF-8 sequence leading byte */
    if((b & 0xC0) == 0xC0) {
        /* Count bytes and eat lead bits */
        for(n = 0; b & 0x80; b<<=1, n++);
        b = (b & 0xFF) >> n;

        if(n > 6 || n < 2) return 0xFFFD;

        switch(n) {
            case 6: b <<= 6;
            case 5: b <<= 6;
            case 4: b <<= 6;
            case 3: b <<= 6;
            case 2: b <<= 6;
        }
        character = b;
        
        for(i = n; i>1; i--) {
            b = fgetc(stream);
            if(b == EOF) return 0xFFFD;
            if((b & 0xC0) != 0x80) return 0xFFFD;
            b &= 0x3F;

            switch(i) {
                case 6: b <<= 6;
                case 5: b <<= 6;
                case 4: b <<= 6;
                case 3: b <<= 6;
                case 2: ;
            }
            
            character |= b;
        }

        /* Check for overlong sequences */
        switch(n) {
            case 6: if(character < 0x4000000) return 0xFFFD;
            case 5: if(character < 0x200000) return 0xFFFD;
            case 4: if(character < 0x10000) return 0xFFFD;
            case 3: if(character < 0x800) return 0xFFFD;
            case 2: if(character < 0x80) return 0xFFFD;
        }

        return character;
    }

    /* UTF-8 sequence continuation byte */
    else if((b & 0xC0) == 0x80) {
        return 0xFFFD;
    }

    /* ASCII character */
    else {
        return (CHAR)b;
    }
}
    
void 
translate(FILE *in, FILE *out)
{
    CHAR character;
    
    while(!feof(in))
    {
        character = read_utf8_char(in);

        if(character == 0xFFFFFFFF)
            break;
        
        /* Don't lose null characters in input */
        if(character == 0 && !mtable_get(charmap_table, 0))
            fputc(0, out);
        else
            fputs(get_translation(character), out);
    }
}

#if !HAVE_GETLINE
ssize_t getline(char **lineptr, size_t *n, FILE *stream)
{
    ssize_t k = 0;
    int c;

    if(!*lineptr) {
        *lineptr = malloc(256);
        if(!*lineptr)
            return -1;
        *n = 256;
    }

    do {
        c = fgetc(stream);
        if(c == EOF) {
            if(k == 0) {
                (*lineptr)[0] = 0;
                return -1;
            }
            
            break;
        }

        if(k == *n - 1) {
            char *p = realloc(*lineptr, *n *2);
            if(!p)
                return -1;
            *lineptr = p;
        }

        (*lineptr)[k++] = c;
    } while(c != '\n');

    (*lineptr)[k] = 0;
    
    return k;
}
#endif
