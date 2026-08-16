#
# SYNOPSIS
#
#   TSU_FIX_MAKEFILE(EXTRA_PERL,EXTRA_COMMANDS,INIT_COMMANDS)
#
# DESCRIPTION
#
#   Alter the Automake-generated Makefile to do certain things needed by
#   Tsukurimashou that don't seem to be achievable in any simpler way.
#   This works by adding a "fix-makefile" tag to config.status and
#   making other changes to make sure that this tag will be executed any
#   time the Makefile is rebuilt.
#
#   This code uses a perl -pe loop over the Makefile, and additional hacks
#   on the Makefile may be done by passing suitable Perl code in the
#   EXTRA_PERL argument.  Further shell commands that won't fit in that
#   context may be added in the EXTRA_COMMANDS argument.
#
#   Any shell commands given in INIT_COMMANDS are added to the
#   corresponding argument of AC_CONFIG_COMMANDS.
#
#   TSU_FIX_MAKEFILE must be used early in the configure.ac, in particular
#   before anything that causes Autoconf to include stuff related to the
#   C compiler.
#
#   To make it more secure that the fix-makefile commands really will
#   be executed, include a line like this one in Makefile.am:
#      $(error This Makefile must be edited by Perl code in config.status before use)
#   The default fix-makefile loop will remove it, but when present this
#   line prevents anyone from using a Makefile that might somehow have
#   been created and not processed by fix-makefile.
#
#   The regular expression /ZZZZHACKZZZZ\s*=\s*/ will be removed from
#   Makefile lines.  This behaviour can be used to make a line of 
#   something other than variable definitions *look* like a variable
#   definition, so that Automake will include it early in the generated
#   Makefile, among the variable definitions.
#
# LICENSE
#
#   This macro is released to the public domain by its author,
#   Matthew Skala <mskala@ansuz.sooke.bc.ca>.

#serial 1

AC_DEFUN([TSU_FIX_MAKEFILE], [
  AC_CONFIG_COMMANDS([fix-makefile],
    [patsubst(["$PERL" -i -pe 'dnl
dnl
dnl Remove ZZZZHACKZZZZ= to allow forcing lines to be early
s/ZZZZHACKZZZZ\s*=\s*//;dnl
dnl
dnl Remove Makefile poison pill (to prevent user from overriding us)
$_="" if /\$\(error This Makefile must be /;dnl
dnl
dnl Any time the Makefile wants to run automake --foreign and not us,
dnl also run ourselves
s#(\$\(AUTOMAKE\) --foreign( Makefile)?)(?! && (\S+\s+)?./config)#dnl
\1 && \$(SHELL) ./config.status fix-makefile#;dnl
dnl
dnl Any time it wants to run config_status in the way that Automake does
dnl it to invoke depfiles, also run ourselves
s#config\.status \$\@ \$\(am__depfiles_maybe\)#dnl
config.status \$\@ fix-makefile \$(am__depfiles_maybe)#;dnl
dnl
dnl Change lines that look like Automake's "make clean" recipes, to
dnl use our pretty output format.
s#\t-\@?(test -z.* || )?rm -(r?)f (.*)#dnl
\t\$(TSU_V_RM) '"'"'\3'"'"' \$(TSU_V_CHOPPER)\ndnl
\t-\$(A''M_V_at)\1rm -\2f \3#;dnl
dnl
dnl Similar change for the VPATH-only files
s#\t-\@?(test \. =.* || test -z.* || )rm -(r?)f (.*)#dnl
\t-@\1(\$(TSU_V_RM) '"'"'\3'"'"' \$(TSU_V_CHOPPER) ; dnl
rm -\2f \3)#;dnl
dnl
$1' Makefile
$2],[dnl.*
],[])],
    [PERL=$PERL
$3])
])
