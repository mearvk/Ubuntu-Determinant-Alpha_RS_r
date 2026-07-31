/*
  Copyright (c) 2009-2017 Dave Gamble and cJSON contributors

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

  -----------------------------------------------------------------------
  NOTE: This is a STUB header. The full cJSON source (~1700 lines) should
  be fetched at build time via 'make' which downloads from:
    https://github.com/DaveGamble/cJSON

  This header provides the API declarations so dave_web.c can compile
  and reference the types. The actual implementation is in cJSON.c.
  -----------------------------------------------------------------------
*/

#ifndef cJSON__h
#define cJSON__h

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

/* cJSON Types */
#define cJSON_Invalid   (0)
#define cJSON_False     (1 << 0)
#define cJSON_True      (1 << 1)
#define cJSON_NULL      (1 << 2)
#define cJSON_Number    (1 << 3)
#define cJSON_String    (1 << 4)
#define cJSON_Array     (1 << 5)
#define cJSON_Object    (1 << 6)
#define cJSON_Raw       (1 << 7)

#define cJSON_IsReference  256
#define cJSON_StringIsConst 512

/* The cJSON structure */
typedef struct cJSON {
    struct cJSON *next;
    struct cJSON *prev;
    struct cJSON *child;
    int type;
    char *valuestring;
    int valueint;
    double valuedouble;
    char *string;
} cJSON;

/* Supply malloc/free functions */
typedef struct cJSON_Hooks {
    void *(*malloc_fn)(size_t sz);
    void (*free_fn)(void *ptr);
} cJSON_Hooks;

/* Core API */
extern cJSON *cJSON_Parse(const char *value);
extern cJSON *cJSON_ParseWithLength(const char *value, size_t buffer_length);
extern char  *cJSON_Print(const cJSON *item);
extern char  *cJSON_PrintUnformatted(const cJSON *item);
extern void   cJSON_Delete(cJSON *item);

/* Array access */
extern int    cJSON_GetArraySize(const cJSON *array);
extern cJSON *cJSON_GetArrayItem(const cJSON *array, int index);

/* Object access */
extern cJSON *cJSON_GetObjectItem(const cJSON *object, const char *string);
extern cJSON *cJSON_GetObjectItemCaseSensitive(const cJSON *object, const char *string);

/* Type checks */
extern int cJSON_IsInvalid(const cJSON *item);
extern int cJSON_IsFalse(const cJSON *item);
extern int cJSON_IsTrue(const cJSON *item);
extern int cJSON_IsBool(const cJSON *item);
extern int cJSON_IsNull(const cJSON *item);
extern int cJSON_IsNumber(const cJSON *item);
extern int cJSON_IsString(const cJSON *item);
extern int cJSON_IsArray(const cJSON *item);
extern int cJSON_IsObject(const cJSON *item);
extern int cJSON_IsRaw(const cJSON *item);

/* Creation */
extern cJSON *cJSON_CreateNull(void);
extern cJSON *cJSON_CreateTrue(void);
extern cJSON *cJSON_CreateFalse(void);
extern cJSON *cJSON_CreateBool(int boolean);
extern cJSON *cJSON_CreateNumber(double num);
extern cJSON *cJSON_CreateString(const char *string);
extern cJSON *cJSON_CreateRaw(const char *raw);
extern cJSON *cJSON_CreateArray(void);
extern cJSON *cJSON_CreateObject(void);

/* Array manipulation */
extern int    cJSON_AddItemToArray(cJSON *array, cJSON *item);
extern int    cJSON_AddItemToObject(cJSON *object, const char *string, cJSON *item);
extern cJSON *cJSON_AddNullToObject(cJSON *object, const char *name);
extern cJSON *cJSON_AddTrueToObject(cJSON *object, const char *name);
extern cJSON *cJSON_AddFalseToObject(cJSON *object, const char *name);
extern cJSON *cJSON_AddBoolToObject(cJSON *object, const char *name, int boolean);
extern cJSON *cJSON_AddNumberToObject(cJSON *object, const char *name, double number);
extern cJSON *cJSON_AddStringToObject(cJSON *object, const char *name, const char *string);
extern cJSON *cJSON_AddRawToObject(cJSON *object, const char *name, const char *raw);
extern cJSON *cJSON_AddObjectToObject(cJSON *object, const char *name);
extern cJSON *cJSON_AddArrayToObject(cJSON *object, const char *name);

/* Duplicate */
extern cJSON *cJSON_Duplicate(const cJSON *item, int recurse);

/* Memory */
extern void cJSON_InitHooks(cJSON_Hooks *hooks);
extern void cJSON_free(void *object);

#ifdef __cplusplus
}
#endif

#endif /* cJSON__h */
