
/**
 *  @file xml2ag.c
 *
 *  This is the main routine for xml2ag.
 *
 *  @group xml2ag
 *  @{
 */
/*
 *  xml2ag Copyright (C) 2002-2018 by Bruce Korb - all rights reserved
 *  This file is part of AutoGen.
 *  AutoGen Copyright (C) 1992-2017 by Bruce Korb - all rights reserved
 *
 *  AutoGen is free software: you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  AutoGen is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

static char const zConflict[] =
    "the file name operand conflicts with the definitions option.\n";

static char const zTextFmt[] =
    "text = '%s';\n";

static char const * typeName[] = {
    "0 - inval",
    "ELEMENT_NODE",
    "ATTRIBUTE_NODE",
    "TEXT_NODE",
    "CDATA_SECTION_NODE",
    "ENTITY_REF_NODE",
    "ENTITY_NODE",
    "PI_NODE",
    "COMMENT_NODE",
    "DOCUMENT_NODE",
    "DOCUMENT_TYPE_NODE",
    "DOCUMENT_FRAG_NODE",
    "NOTATION_NODE",
    "HTML_DOCUMENT_NODE",
    "DTD_NODE",
    "ELEMENT_DECL",
    "ATTRIBUTE_DECL",
    "ENTITY_DECL",
    "NAMESPACE_DECL",
    "XINCLUDE_START",
    "XINCLUDE_END",
    "DOCB_DOCUMENT_NODE" };

int   level = 0;
FILE * ag_pipe_fp;

#define CHUNK_SZ  4096

#define TRIM(s,psz) trim( (char const *)(s), (size_t *)(psz) )

extern void       fork_ag(char const * pzInput);
static char *     loadFile(FILE * fp, size_t * pzSize);
static xmlNodePtr printHeader(xmlDocPtr pDoc);
static void       printAttrs(xmlAttrPtr pAttr);
static void       printChildren(xmlNodePtr pNode);

int
main(int argc, char ** argv)
{
    xmlDocPtr   pDoc;
    char const * pzFile = NULL;

    {
        int ct = optionProcess( &xml2agOptions, argc, argv );
        argc -= ct;
        argv += ct;

        switch (argc) {
        case 1:
            if (strcmp( *argv, "-" ) != 0) {
                if (HAVE_OPT( DEFINITIONS )) {
                    fprintf(stderr, zConflict);
                    USAGE( EXIT_FAILURE );
                }
                pzFile = *argv;
                break;
            }
            /* FALLTHROUGH */
        case 0:
            if (   HAVE_OPT( DEFINITIONS )
               && (strcmp( OPT_ARG( DEFINITIONS ), "-" ) != 0) )

                pzFile = OPT_ARG( DEFINITIONS );
            break;

        default:
            fprintf(stderr, "only one argument allowed\n");
            return EXIT_FAILURE;
        }
    }

    if (! HAVE_OPT( OUTPUT ))
        fork_ag(pzFile);
    else
        ag_pipe_fp = stdout;

    if (pzFile != NULL) {
        fprintf(ag_pipe_fp, "/* Parsing file %s */\n", pzFile);
        pDoc = xmlParseFile( pzFile );
    }
    else {
        size_t sz;
        char * pz = loadFile( stdin, &sz );
        pDoc = xmlParseMemory( pz, (int)sz );
        fprintf(ag_pipe_fp, "/* Parsed from stdin */\n");
    }

    {
        static char const z_not_doc[] =
            "/* type %d doc is not DOCUMENT or HTML_DOCUMENT */\n";

        xmlNodePtr pRoot = printHeader( pDoc );
        printAttrs( pRoot->properties );
        switch (pDoc->type) {
        case XML_DOCUMENT_NODE:
        case XML_HTML_DOCUMENT_NODE:
            printChildren( pRoot->children );
            break;
        default:
            fprintf(ag_pipe_fp, z_not_doc, pDoc->type);
        }
    }

    xmlCleanupParser();
    return 0;
}


static char *
loadFile(FILE * fp, size_t * pzSize)
{
    size_t  asz = CHUNK_SZ;
    size_t  usz = 0;
    char *  mem = malloc( asz );

    for (;;) {

        if ((usz + CHUNK_SZ) > asz) {
            asz += CHUNK_SZ;
            mem = realloc( mem, asz );
        }

        if (mem == NULL) {
            fprintf(stderr, "Cannot allocate %d byte bufer\n", (int)asz);
            exit( EXIT_FAILURE );
        }

        {
            size_t rdct = fread(mem + usz, (size_t)1, (size_t)CHUNK_SZ, fp);
            usz += rdct;
            if (rdct < CHUNK_SZ)
                break;
        }
    }

    *pzSize = usz;
    return mem;
}


static void
emitIndentation( void )
{
    int indent = level * 2;
    while (--indent >= 0) fputc( ' ', ag_pipe_fp );
}


static char *
trim(char const * pzSrc, size_t * pSz)
{
    static char   zNil[1] = "";
    static char * pzData  = NULL;
    static size_t dataLen = 0;
    size_t        strSize;

    if (pzSrc == NULL) {
        if (pSz != NULL) *pSz = 0;
        return zNil;
    }

    /*
     *  Trim leading and trailing white space.
     */
    while (isspace( *pzSrc ))  pzSrc++;

    {
        char const * pzEnd = pzSrc + strlen( pzSrc );
        while ((pzEnd > pzSrc) && isspace( pzEnd[-1] ))  pzEnd--;

        if (pzEnd <= pzSrc) {
            if (pSz != NULL) *pSz = 0;
            return zNil;
        }
        strSize = (size_t)(pzEnd - pzSrc);
    }

    /*
     *  Count the extra backslashes required and ensure our buffer is
     *  big enough to hold the newly formed string.
     */
    {
        char const * pz = pzSrc;
        for (;;) {
            pz += strcspn( pz, "'\\" );
            if (*(pz++) == NUL)
                break;
            strSize++;
        }
    }

    if (dataLen <= strSize) {
        size_t sz = (strSize + 0x1000) & ~0x0FFFUL;
        if (pzData == NULL)
             pzData = malloc( sz );
        else pzData = realloc( pzData, sz );
        if (pzData == NULL) {
            fprintf(stderr, "ENOMEM allocating 0x%X bytes", (unsigned)sz);
            exit( EXIT_FAILURE );
        }
        dataLen = sz;
    }

    /*
     *  Copy the data, adding backslashes in front of
     *  single quotes and backslashes.
     */
    {
        char * pzDest = pzData;
        for (;;) {
            switch (*(pzDest++) = *(pzSrc++)) {
            case '\'': pzDest[-1]  = '\\'; *(pzDest++) = '\''; break;
            case '\\': *(pzDest++) = '\\'; break;
            case NUL:  goto set_size;
            }
            if (pzDest == pzData + strSize)
                break;
        }

        *pzDest = '\0';
    }

 set_size:
    if (pSz != NULL) *pSz = strSize;
    return pzData;
}

static xmlNodePtr
printHeader(xmlDocPtr pDoc)
{
    static char const def_hdr[] = "AutoGen Definitions %s%s;\n";
    static char const xml_fmt[] = "XML-%s = '%s';\n";

    char const * suffx = ".tpl";

    xmlNodePtr root_node = xmlDocGetRootElement( pDoc );
    xmlChar *  tmp_tpl = NULL;
    xmlChar *  tpl_nm;

    if (root_node == NULL) {
        fprintf(stderr, "Root node not found\n");
        exit( EXIT_FAILURE );
    }

    if (HAVE_OPT( OVERRIDE_TPL )) {
        if (strchr( OPT_ARG( OVERRIDE_TPL ), '.' ) != NULL)
            suffx = "";
        tpl_nm = (xmlChar *)VOIDP(OPT_ARG( OVERRIDE_TPL ));
    }
    else {
        tmp_tpl = xmlGetProp(root_node, (xmlChar *)VOIDP("template"));
        if (tmp_tpl == NULL) {
            fprintf(stderr, "No template was specified.\n");
            exit( EXIT_FAILURE );
        }

        tpl_nm = tmp_tpl;
        if (strchr( (char *)tpl_nm, '.' ) != NULL)
            suffx = "";
    }

    fprintf(ag_pipe_fp, def_hdr, tpl_nm, suffx);
    if (tmp_tpl != NULL)
        free(tmp_tpl);

    if (pDoc->name != NULL)
        fprintf(ag_pipe_fp, xml_fmt, "name",     TRIM(pDoc->name, NULL));

    if (pDoc->version != NULL)
        fprintf(ag_pipe_fp, xml_fmt, "version",  TRIM(pDoc->version, NULL));

    if (pDoc->encoding != NULL)
        fprintf(ag_pipe_fp, xml_fmt, "encoding", TRIM(pDoc->encoding, NULL));

    if (pDoc->URL != NULL)
        fprintf(ag_pipe_fp, xml_fmt, "URL",      TRIM(pDoc->URL, NULL));

    if (pDoc->standalone)
        fprintf(ag_pipe_fp, xml_fmt, "standalone", "true");

    return root_node;
}

static void
printAttrs(xmlAttrPtr pAttr)
{
    while (pAttr != NULL) {
        char * pzCont = (char *)pAttr->children->content;

        emitIndentation();
        fputs( (char *)VOIDP(pAttr->name), ag_pipe_fp );
        fputs( " = ", ag_pipe_fp );
        if (pAttr->children->children == NULL)
            fprintf(ag_pipe_fp, "'%s';\n", TRIM(pzCont, NULL));
        else {
            fputs( "{\n", ag_pipe_fp );
            level++;
            if (pzCont != NULL) {
                emitIndentation();
                fprintf(ag_pipe_fp, zTextFmt, TRIM(pzCont, NULL));
            }
            printChildren( pAttr->children->children );
            level--;
            emitIndentation();
            fputs( "};\n", ag_pipe_fp );
        }

        pAttr = pAttr->next;
    }
}


static void
printNode(xmlNodePtr pNode)
{
    switch (pNode->type) {
    case XML_ELEMENT_NODE:
    {
        size_t sz;
        char * pzTxt;
        emitIndentation();
        fputs( (char *)VOIDP(pNode->name), ag_pipe_fp );
        pzTxt = TRIM(pNode->content, &sz);

        if (  (pNode->properties == NULL)
           && (pNode->children == NULL)) {

            if (sz == 0)
                 fputs( ";\n", ag_pipe_fp );
            else fprintf(ag_pipe_fp, " = '%s';\n", pzTxt);
            break;
        }

        fputs( " = {\n", ag_pipe_fp );
        level++;
        emitIndentation();
        fprintf(ag_pipe_fp, "content = '%s';\n", pzTxt);
        printAttrs( pNode->properties );
        printChildren( pNode->children );
        level--;
        emitIndentation();
        fputs( "};\n", ag_pipe_fp );
        break;
    }

    case XML_ATTRIBUTE_NODE:
        fputs( "Misplaced attribute\n", ag_pipe_fp );
        exit( EXIT_FAILURE );

    case XML_TEXT_NODE:
    {
        size_t sz;
        char * pzTxt = TRIM(pNode->content, &sz);
        if (sz == 0)
            break;
        emitIndentation();
        fprintf(ag_pipe_fp, zTextFmt, pzTxt);
        break;
    }

    case XML_COMMENT_NODE:
    {
        size_t sz;
        char * pzTxt = TRIM(pNode->content, &sz);
        if (sz == 0)
            break;

        emitIndentation();
        fputs( "/* ", ag_pipe_fp );
        for (;;) {
            char * pz = strstr( pzTxt, "*/" );
            if (pz == NULL)
                break;
            fwrite(pzTxt, (size_t)((pz - pzTxt) + 1), (size_t)1, ag_pipe_fp);
            pzTxt = pz+1;
            fputc( ' ', ag_pipe_fp );
        }
        fprintf(ag_pipe_fp, "%s */\n", pzTxt);
        break;
    }

    case XML_CDATA_SECTION_NODE:
    case XML_ENTITY_REF_NODE:
    case XML_ENTITY_NODE:
    case XML_PI_NODE:

    case XML_DOCUMENT_NODE:
    case XML_HTML_DOCUMENT_NODE:
    case XML_DOCUMENT_TYPE_NODE:
    case XML_DOCUMENT_FRAG_NODE:
    case XML_NOTATION_NODE:
    case XML_DTD_NODE:
    case XML_ELEMENT_DECL:
    case XML_ATTRIBUTE_DECL:
    case XML_ENTITY_DECL:
    case XML_NAMESPACE_DECL:
    case XML_XINCLUDE_START:
    case XML_XINCLUDE_END:
        emitIndentation();
        fprintf(ag_pipe_fp, "/* Unsupported XML node type:  %s */\n",
                typeName[ pNode->type ]);
        break;

    default:
        emitIndentation();
        fprintf(ag_pipe_fp, "/* Unknown XML node type %d */\n", pNode->type);
        break;
    }
}


static void
printChildren(xmlNodePtr pNode)
{
    while (pNode != NULL) {
        printNode( pNode );
        pNode = pNode->next;
    }
}

/*
 * Local Variables:
 * mode: C
 * c-file-style: "stroustrup"
 * indent-tabs-mode: nil
 * End:
 * end of xml2ag/xml2ag.c */
