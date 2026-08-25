/*
 * xmc integrated driver.
 * The compiler core produces .xclass; this driver composes the result into
 * an ASYSMA artifact with a target-native bootstrap as its executable prefix.
 */
#include "xmc-version.h"
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static void usage(const char *p) { fprintf(stderr,"usage: %s [--version] [xmc-options] SOURCE.java\n",p); }
static int run(char *const argv[]) {
    pid_t pid=fork(); if(pid<0){perror("xmc: fork");return 1;}
    if(pid==0){execv(argv[0],argv);perror(argv[0]);_exit(127);}
    int status=0; if(waitpid(pid,&status,0)<0){perror("xmc: waitpid");return 1;}
    return WIFEXITED(status)?WEXITSTATUS(status):1;
}
static int find_source(int argc,char **argv){for(int i=argc-1;i>=1;--i)if(argv[i][0]!='-')return i;return -1;}
static int is_java(const char *p){const char *d=strrchr(p,'.');return d&&strcmp(d,".java")==0;}
static int exists_exec(const char *p){struct stat st;return stat(p,&st)==0&&S_ISREG(st.st_mode)&&access(p,X_OK)==0;}

int main(int argc,char **argv){
    if(argc==2&&(!strcmp(argv[1],"--version")||!strcmp(argv[1],"-V"))){printf("xmc %s\n",XMC_VERSION);return 0;}
    if(argc<2){usage(argv[0]);return 2;}
    char self[PATH_MAX]; ssize_t n=readlink("/proc/self/exe",self,sizeof self-1);
    if(n<=0||n>=(ssize_t)sizeof self-1){fprintf(stderr,"xmc: cannot locate integrated compiler directory\n");return 1;}
    self[n]='\0'; char *slash=strrchr(self,'/'); if(!slash)return 1; *slash='\0';
    char core[PATH_MAX],packer[PATH_MAX],launcher[PATH_MAX],bootstrap[PATH_MAX];
    snprintf(core,sizeof core,"%s/xmc-core",self); snprintf(packer,sizeof packer,"%s/asysma_pack",self);
    snprintf(launcher,sizeof launcher,"%s/xmc-asysma-launcher.sh",self);
    snprintf(bootstrap,sizeof bootstrap,"%s/asysma-bootstrap",self);
    int source_index=find_source(argc,argv); if(source_index<0){usage(argv[0]);return 2;}
    const char *source=argv[source_index];
    char **core_argv=calloc((size_t)argc+1,sizeof(char*)); if(!core_argv){perror("xmc: calloc");return 1;}
    core_argv[0]=core; for(int i=1;i<argc;++i)core_argv[i]=argv[i]; core_argv[argc]=NULL;
    fprintf(stdout,"xmc %s: integrated ASYSMA mode\n",XMC_VERSION);
    int rc=run(core_argv); free(core_argv);
    if(rc!=0){fprintf(stderr,"xmc: compiler core failed; ASYSMA composition skipped\n");return rc;}
    if(!is_java(source)){fprintf(stdout,"xmc: ASYSMA composition currently requires a Java entry source; .xclass retained\n");return 0;}
    if(!exists_exec(bootstrap)){
        fprintf(stderr,"xmc: self-contained ASYSMA bootstrap is not built: %s\n",bootstrap);
        fprintf(stderr,"xmc: build target 'asysma-bootstrap' before producing standalone .asysma output\n");
        return 1;
    }
    char base[PATH_MAX]; snprintf(base,sizeof base,"%s",source); char *dot=strrchr(base,'.'); if(dot)*dot='\0';
    char xclass[PATH_MAX],asysma[PATH_MAX],desktop[PATH_MAX];
    snprintf(xclass,sizeof xclass,"%s.xclass",base); snprintf(asysma,sizeof asysma,"%s.asysma",base);
    snprintf(desktop,sizeof desktop,"%s.asysma.desktop",base);
    char class_name[PATH_MAX]; const char *leaf=strrchr(base,'/'); snprintf(class_name,sizeof class_name,"%s",leaf?leaf+1:base);
    char icon[PATH_MAX]; snprintf(icon,sizeof icon,"%s/xmc-icon.svg",self);
    char sha_cmd[PATH_MAX+32]; snprintf(sha_cmd,sizeof sha_cmd,"sha256sum '%s' 2>/dev/null",icon);
    FILE *pipe=popen(sha_cmd,"r"); char icon_sha[65]="unavailable";
    if(pipe){if(fscanf(pipe,"%64s",icon_sha)!=1)strcpy(icon_sha,"unavailable");pclose(pipe);}
    char *pack_argv[]={packer,"--output",asysma,"--entry","JAVA","--java",class_name,
        "--xclass",xclass,"--bootstrap",bootstrap,"--icon",icon,"--icon-sha256",icon_sha,NULL};
    rc=run(pack_argv); if(rc!=0){fprintf(stderr,"xmc: .xclass succeeded but ASYSMA composition failed\n");return rc;}
    FILE *d=fopen(desktop,"w"); if(!d){perror(desktop);return 1;}
    fprintf(d,"[Desktop Entry]\nType=Application\nName=%s (ASYSMA)\nComment=Run the compiled ASYSMA application\nIcon=%s\nExec=%s %%U\nTerminal=false\nMimeType=application/x-asysma;\nCategories=Development;\nStartupNotify=true\n",class_name,icon,launcher); fclose(d);
    printf("xmc: %s.xclass\n",class_name); printf("xmc: %s.asysma\n",class_name); printf("xmc: %s.asysma.desktop\n",class_name); printf("xmc: icon SHA-256 %s\n",icon_sha);
    return 0;
}
