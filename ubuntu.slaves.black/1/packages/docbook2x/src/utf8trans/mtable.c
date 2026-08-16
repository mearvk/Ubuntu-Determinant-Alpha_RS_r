#include "mtable.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define mtable_left_index(k, e)   ((~((1<<(e))-1) & (k))>>(e))
#define mtable_right_index(k, e)  (((1<<(e))-1) & (k))

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

static mtable_t 
mtable_new2(int *exponents)
{
    void **p = mallocc(sizeof(void *) * (1 + (1<<exponents[0])));
    p[0] = exponents;
    memset(p+1, 0, sizeof(void *) * (1<<exponents[0]));
    return (mtable_t) p;
}

mtable_t 
mtable_new(int *exponents)
{
    int n;
    int *exponents_copy;
    
    for(n=0; exponents[n++] != 0; );
    exponents_copy = mallocc(sizeof(int) * n);
    while(n > 0) {
        n--;
        exponents_copy[n] = exponents[n];
    }

    return mtable_new2(exponents_copy);
}

static void 
mtable_delete2(mtable_t mtab, int e_sum, int start)
{
    if(mtab->exponents[1] != 0) {
        int k;
        int e = mtab->exponents[0];
        void **p = &(mtab->slots[0]);
        for(k=0; k<(1<<e); k++) {
            if(*p != NULL)
                mtable_delete2(*p, e_sum-e, start+(k<<(e_sum-e)));
            p++;
        }
    }
    free(mtab);
}
    
void 
mtable_delete(mtable_t mtab)
{
    int i, e_sum=0, *exponents;
    for(i=0; mtab->exponents[i] != 0; i++)
        e_sum += mtab->exponents[i];

    exponents = mtab->exponents;
    mtable_delete2(mtab, e_sum, 0);
    free(exponents);
}

#if 0
static void
mtable_change_exponents(mtable_t mtab, int *exponents)
{
    if(mtab->exponents[1] != 0) {
        int k;
        int e = mtab->exponents[0];
        void **p = &(mtab->slots[0]);
        for(k=0; k<(1<<e); k++) {
            if(*p != NULL)
                mtable_change_exponents(*p, exponents+1);
            p++;
        }
    }
    mtab->exponents = exponents;
}

mtable_t
mtable_extend(mtable_t mtab, int *exponents)
{
    struct mtable *p;
    int *all_exponents, *old_exponents;
    int n = 0;
    int i = 0;

    for(n=0; exponents[n++] != 0; );
    for(i=0; mtab->exponents[i++] != 0; );
    all_exponents = mallocc(sizeof(int) * (n-1+i));
    for(i=0; exponents[i] != 0; i++)
        all_exponents[i] = exponents[i];
    for(i=0; mtab->exponents[i] != 0; i++)
        all_exponents[n-1+i] = mtab->exponents[i];
    all_exponents[n-1+i] = 0;
        
    p = mtable_new2(exponents);
    mtable_set(p, 0, mtab);

    old_exponents = mtab->exponents;
    mtable_change_exponents(p, all_exponents);
    mtable_change_exponents(mtab, all_exponents+n-1);
    free(old_exponents);

    return p;
}
#endif

void
mtable_set(mtable_t mtab, mtable_key key, void *data)
{
    int i, e=0;
    struct mtable *p;
    mtable_key k;
    
    for(i=0; mtab->exponents[i] != 0; i++)
        e += mtab->exponents[i];

    p = mtab;
    k = key;
    
    for(;;) {
        if(p->exponents[1] == 0) {
            p->slots[k] = data;
            return;
        } else {
            e -= p->exponents[0];
            i = mtable_left_index(k, e);
            k = mtable_right_index(k, e);

            if(p->slots[i] == NULL) 
                p->slots[i] = mtable_new2(p->exponents+1);

            p = p->slots[i];
        }
    }
}
        
void 
*mtable_get(mtable_t mtab, mtable_key key)
{
    int i, e=0;
    struct mtable *p;
    mtable_key k;
    
    for(i=0; mtab->exponents[i] != 0; i++)
        e += mtab->exponents[i];

    p = mtab;
    k = key;
  
    while(p != NULL) {
        if(p->exponents[1] == 0) {
            return p->slots[k];
        } else {
            e -= p->exponents[0];
            i = mtable_left_index(k, e);
            k = mtable_right_index(k, e);
            
            p = p->slots[i];
        }
    }

    return NULL;
}
