@echo off

@call setenvvar.bat
@if errorlevel 1 (goto :END)

set FB_CLEAN_SHARED=

:: Read the command line
for %%v in ( %* )  do (
( if /I "%%v"=="REALCLEAN" (set FB_CLEAN_SHARED=1) )
)

@echo Cleaning temporary directories...
@rmdir /S /Q %FB_OUTPUT_DIR% 2>nul
@rmdir /S /Q %FB_TEMP_DIR% 2>nul
@rmdir /S /Q %FB_ROOT_PATH%\builds\zip_pack_%FB_TARGET_PLATFORM% 2>nul

@echo Cleaning gen...
@rmdir /S /Q %FB_GEN_DIR% 2>nul

@echo Cleaning icu...
@rmdir /S /Q %FB_ROOT_PATH%\extern\icu\%FB_TARGET_PLATFORM%\%FBBUILD_BUILDTYPE% 2>nul

@echo Cleaning libtommath...
@rmdir /S /Q %FB_ROOT_PATH%\extern\libtommath\lib\%FB_TARGET_PLATFORM% 2>nul
@rmdir /S /Q %FB_ROOT_PATH%\extern\libtommath\temp\%FB_TARGET_PLATFORM% 2>nul

:: Removing these might screw up parallel builds.
:: So let's be sure we mean it.
if defined FB_CLEAN_SHARED (

@echo Cleaning icu Shared dirs...
@rmdir /S /Q %FB_ROOT_PATH%\extern\icu\include

@echo Cleaning zlib...
@rmdir /S /Q %FB_ROOT_PATH%\extern\zlib\%FB_TARGET_PLATFORM% 2>nul
@del %FB_ROOT_PATH%\extern\zlib\zconf.h 2>nul
@del %FB_ROOT_PATH%\extern\zlib\zlib.h 2>nul

@echo Cleaning shared gen and dsql files...
@del %FB_ROOT_PATH%\src\include\gen\parse.h
@del %FB_ROOT_PATH%\src\dsql\dsql.tab.h
@del %FB_ROOT_PATH%\src\dsql\parse.cpp

)

@echo Cleaning install and build files...
@del *%FB_TARGET_PLATFORM%.log 2>nul
@del *.manifest 2>nul

@echo Completed executing %0
@echo.

