/*
 * aulog.h
 *
 * $Id: aulog.h 227 2006-09-01 05:57:17Z jon $
 *
 * Jon Trulson 9/11/99
 */

#ifndef AULOG_H_INCLUDED
#define AULOG_H_INCLUDED

#define LOG_BUFSIZE 4096
#define LOG_FILENMSZ 1024

void osLogMsg(const char *fmt, ...);

#endif /* AULOG_H_INCLUDED */
