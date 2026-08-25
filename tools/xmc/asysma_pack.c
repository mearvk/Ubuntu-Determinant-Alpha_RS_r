/*
 * XMC ASYSMA self-contained package writer.
 * A target-native bootstrap is prepended; the ASYSMAEX layout and payload
 * follow it so the bootstrap can validate and delegate to the OS loader.
 */
#include "asysma_native_layout.h"
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int copy_file(FILE *out, const char *path, uint64_t *size) {
    FILE *in = fopen(path, "rb");
    unsigned char buf[65536]; size_t n;
    if (!in) return -1; *size = 0;
    while ((n = fread(buf, 1, sizeof buf, in)) != 0) {
        if (fwrite(buf, 1, n, out) != n) { fclose(in); return -1; }
        *size += n;
    }
    if (ferror(in)) { fclose(in); return -1; }
    fclose(in); return 0;
}

static void usage(const char *p) {
    fprintf(stderr,
        "usage: %s --output FILE --entry JAVA|NATIVE|NATIVE_THEN_JAVA "
        "--java CLASS --bootstrap FILE [--xclass FILE] [--native FILE] "
        "[--icon FILE] [--icon-sha256 HEX]\n", p);
}

int main(int argc, char **argv) {
    const char *out_path=NULL,*entry=NULL,*java_entry=NULL,*xclass=NULL,*native_payload=NULL;
    const char *bootstrap=NULL,*icon=NULL,*icon_sha256=NULL;
    FILE *out=NULL; uint64_t bs=0, icon_size=0, native_size=0, xclass_size=0;
    for (int i=1;i<argc;i++) {
        if (!strcmp(argv[i],"--output")&&i+1<argc) out_path=argv[++i];
        else if (!strcmp(argv[i],"--entry")&&i+1<argc) entry=argv[++i];
        else if (!strcmp(argv[i],"--java")&&i+1<argc) java_entry=argv[++i];
        else if (!strcmp(argv[i],"--xclass")&&i+1<argc) xclass=argv[++i];
        else if (!strcmp(argv[i],"--native")&&i+1<argc) native_payload=argv[++i];
        else if (!strcmp(argv[i],"--bootstrap")&&i+1<argc) bootstrap=argv[++i];
        else if (!strcmp(argv[i],"--icon")&&i+1<argc) icon=argv[++i];
        else if (!strcmp(argv[i],"--icon-sha256")&&i+1<argc) icon_sha256=argv[++i];
        else { usage(argv[0]); return 2; }
    }
    if (!out_path||!entry||!java_entry||!bootstrap||
        (strcmp(entry,"JAVA")&&strcmp(entry,"NATIVE")&&strcmp(entry,"NATIVE_THEN_JAVA"))) { usage(argv[0]); return 2; }
    if (!strcmp(entry,"NATIVE")&&!native_payload) { fprintf(stderr,"NATIVE entry requires --native\n"); return 2; }
    if (!strcmp(entry,"NATIVE_THEN_JAVA")&&!native_payload) { fprintf(stderr,"NATIVE_THEN_JAVA requires --native\n"); return 2; }
    if (icon&&!icon_sha256) { fprintf(stderr,"--icon requires --icon-sha256\n"); return 2; }

    out=fopen(out_path,"wb"); if(!out){perror(out_path);return 1;}
    if(copy_file(out,bootstrap,&bs)!=0) goto io_fail;
    long header_pos=ftell(out); if(header_pos<0) goto io_fail;

    char manifest[8192];
    int ml=snprintf(manifest,sizeof manifest,
        "format=ASYSMA\nversion=2\ntarget_os=%s\ntarget_arch=%s\n"
        "entry_type=%s\njava_entry=%s\nxclass=%s\nnative_payload=%s\n"
        "icon=%s\nicon_sha256=%s\nloader_mode=native-bootstrap\n",
#if defined(_WIN32)
        "windows",
#elif defined(__APPLE__)
        "macos",
#else
        "linux",
#endif
#if defined(__aarch64__)
        "aarch64",
#else
        "x86-64",
#endif
        entry,java_entry,xclass?"present":"absent",native_payload?"present":"absent",
        icon?"embedded":"none",icon_sha256?icon_sha256:"unavailable");
    if(ml<0||(size_t)ml>=sizeof manifest){fprintf(stderr,"manifest too large\n");goto io_fail;}

    asysma_native_layout h; memset(&h,0,sizeof h);
    memcpy(h.magic,ASYSMA_NATIVE_MAGIC,8); h.version=ASYSMA_NATIVE_LAYOUT_VERSION; h.header_size=(uint32_t)sizeof h;
#if defined(_WIN32)
    h.target_os=ASYSMA_OS_WINDOWS;
#elif defined(__APPLE__)
    h.target_os=ASYSMA_OS_MACOS;
#else
    h.target_os=ASYSMA_OS_LINUX;
#endif
#if defined(__aarch64__)
    h.target_arch=2;
#else
    h.target_arch=1;
#endif
    h.manifest_offset=(uint64_t)header_pos+sizeof h; h.manifest_size=(uint64_t)ml;
    h.icon_offset=0; h.payload_offset=0;
    if(fwrite(&h,1,sizeof h,out)!=sizeof h)goto io_fail;
    if(fwrite(manifest,1,(size_t)ml,out)!=(size_t)ml)goto io_fail;
    if(icon){h.icon_offset=(uint64_t)ftell(out);if(copy_file(out,icon,&icon_size)!=0)goto io_fail;}
    if(native_payload){h.payload_offset=(uint64_t)ftell(out);if(copy_file(out,native_payload,&native_size)!=0)goto io_fail;}
    if(xclass&&copy_file(out,xclass,&xclass_size)!=0)goto io_fail;
    h.manifest_offset=(uint64_t)header_pos+sizeof h; h.manifest_size=(uint64_t)ml;
    h.icon_size=icon_size; h.payload_size=native_size;
    if(fseek(out,header_pos,SEEK_SET)!=0||fwrite(&h,1,sizeof h,out)!=sizeof h)goto io_fail;
    fclose(out);
    printf("created %s (bootstrap %llu, native %llu, xclass %llu, icon %llu bytes)\n",out_path,
        (unsigned long long)bs,(unsigned long long)native_size,(unsigned long long)xclass_size,(unsigned long long)icon_size);
    return 0;
io_fail:
    fprintf(stderr,"write failed: %s\n",strerror(errno)); if(out)fclose(out); remove(out_path); return 1;
}
