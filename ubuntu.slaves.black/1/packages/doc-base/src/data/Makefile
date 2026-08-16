# vim:ts=2
# makefile for doc-base

ALL_TARGET:=
SUBDIRS:=
include ../common.mk

install-local: 
	$(call msg,$@)
	$(call install,$(sharedir)/doc-base,doc-base.desc,notdir)
	$(call install,$(sharedir)/install-docs-man,install-docs.desc,notdir)
	$(call install,$(sharedir)/data,doc-base.map)
	$(call install,$(etcdir)/documents/README,README.local,notdir)
