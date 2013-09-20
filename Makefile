# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX = /usr
DATA = /share
BIN = /bin
LIB = /lib
SYSCONF = /etc
MODULES = $(PREFIX)$(LIB)
PKGNAME = sweetie-bot
COMMAND = sweetiebot
LICENSES = $(DATA)/licenses

BASH_SHEBANG = $(BIN)/bash
PY3_SHEBANG = /usr$(BIN)/env python3

MODULE_DIR = $(MODULES)/$(PKGNAME)
CONFFILE = $(SYSCONF)/$(PKGNAME).conf



all: sweetiebot doc

doc: info

info: sweetie-bot.info.gz

info/%.texinfo.install: info/%.texinfo
	cp "$<" "$@"
	sed -i 's:^@set MODULE_DIR /usr/lib/sweetie-bot$$:@set MODULE_DIR $(MODULE_DIR):' "$@"
	sed -i 's:^@set CONFFILE /etc/sweetie-bot.conf$$:@set CONFFILE $(CONFFILE):' "$@"
	sed -i 's:^@set COMMAND sweetiebot$$:@set COMMAND $(COMMAND):' "$@"

%.info.gz: info/%.texinfo.install
	makeinfo "$<"
	gzip -9 -f "$*.info"

sweetiebot: src/sweetiebot
	cp "$<" "$@"
	sed -i 's:^#!/usr/bin/env bash$$:#!$(BASH_SHEBANG):' "$@"
	sed -i "s:^MODULE_DIR=/usr/lib/sweetie-bot$$:MODULE_DIR='$(MODULE_DIR)':" "$@"
	sed -i "s:^CONFFILE=/etc/sweetie-bot.conf$$:CONFFILE='$(CONFFILE)':" "$@"



install: sweetiebot sweetie-bot.info.gz
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(BIN)"
	install -m755 sweetiebot -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -m644 COPYING LICENSE -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -dm755 -- "$(DESTDIR)$(PREFIX)$(DATA)/info"
	install -m644 sweetie-bot.info.gz -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"
	install -Dm644 config/sweetie-bot.conf -- "$(DESTDIR)$(CONFFILE)"



uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"
	-rm -- "$(DESTDIR)$(CONFFILE)"



clean:
	-rm -f sweetiebot sweetie-bot.info.gz *.install


.PHONY: all doc info install uninstall clean

