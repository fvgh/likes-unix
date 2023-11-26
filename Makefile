#!/usr/bin/make -f
# vim:syntax=make
# Copyright (c) 2024 Frank Vennemeyer
# SPDX-License-Identifier: 0BSD

#Variables for overriding certain commands, options, and so on
GIT = git
GREP = grep
VIM = vim

#Avoid trouble on systems where the SHELL variable might be inherited from the environment
SHELL = /bin/sh

modified-files = $(shell $(GIT) status -s -uno | $(GREP) -e "^.M")

#ForEach expansion of recipe is triggered at the end of the rule. So it is placed in a dedicated rule.
check.indent: precondition := $(call modified-files)
check.indent: $(shell $(GIT) ls-tree --full-tree --name-only -r HEAD)
	$(if $(precondition), $(error GIT working directory contains unstaged modified files: $(precondition)))
	$(foreach f,$?,$(VIM) -c "set modeline" -c "set modelines=2" -c "set modelineexpr" -c "normal gg=G" -c "x" "$(f)";)
	$(file >$@, Files modified by VIM re-indent:)

check: check.indent
	$(info When TTY mouse is enabled, VIM output contains ^[[I, signaling loss of terminal focus.)
	$(file >>$^, $(shell $(GIT) status -s -uno | $(GREP) -e "^.M"))
	$(file >>$^, Details:)
	$(file >>$^, $(shell $(GIT) diff))
	$(if $(call modified-files), $(error Detected indentation errors. See $@ for details.))

clean: 
	-rm check.indent

all: check

.DEFAULT_GOAL := all
.PHONY: all check clean do.check.indent
