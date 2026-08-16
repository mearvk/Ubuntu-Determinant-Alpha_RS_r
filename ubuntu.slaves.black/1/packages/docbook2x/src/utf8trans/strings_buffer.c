#include "strings_buffer.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define max(a,b) ((a) > (b)? (a) : (b))

static void *
mallocc(size_t size)
{
    void *p = malloc(size);
    if(p == NULL) {
        fprintf(stderr, "out of memory\n");
        abort();
    }
    return p;
}
        
static struct strings_section *
strings_buffer_new2(size_t size, struct strings_section *ss)
{
    struct strings_section *p;
    p = mallocc(sizeof(struct strings_section));
    
    p->cur_size = p->size = size;
    p->cur = p->start = mallocc(size);
    p->next = ss;

    return p;
}

struct strings_section *
strings_buffer_new(size_t size)
{
    return strings_buffer_new2(size, NULL);
}

void
strings_buffer_delete(struct strings_section *ss)
{
    while(ss != NULL) {
        struct strings_section *p = ss;
        ss = ss->next;
        free(p->start);
        free(p);
    }
}

char *
strings_buffer_add(struct strings_section **ss, const char *s)
{
    struct strings_section *p;
    size_t len = strlen(s)+1;

    for(p=*ss; p != NULL; p=p->next) {
        if(p->cur_size >= len) {
            strcpy(p->cur, s);
            p->cur += len;
            p->cur_size -= len;
            return (p->cur - len);
        }
    }
    
    p = strings_buffer_new2(max((*ss)->size, len), *ss);
    strcpy(p->cur, s);
    p->cur += len;
    p->cur_size -= len;
    *ss = p;
    return (p->cur - len);
}

