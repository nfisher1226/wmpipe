DESTDIR ?=
PREFIX ?= /usr/local
BINDIR = $(DESTDIR)${PREFIX}/bin
LIBDIR = $(DESTDIR)${PREFIX}/lib/wmpipe
SYSCONFDIR = ${DESTDIR}/etc/wmpipe

all:
	@echo "Just type \"make install\"."
	@echo "Paths can be tuned with DESTDIR and PREFIX variables."

install-conf:
	install -d ${SYSCONFDIR}
	install -m 644 etc/conf ${SYSCONFDIR}
	install -m 644 etc/icons.conf ${SYSCONFDIR}

install-libs: install-conf
	install -d ${LIBDIR}
	install -m 644 lib/icewm.sh ${LIBDIR}
	install -m 644 lib/openbox.sh ${LIBDIR}
	install -m 644 lib/pekwm.sh ${LIBDIR}

install-sh: install-libs
	install -d ${BINDIR}
	install -m 755 bin/wmpipe_mpd.sh ${BINDIR}
	ln -sf wmpipe_mpd.sh ${BINDIR}/icempd.sh
	ln -sf wmpipe_mpd.sh ${BINDIR}/obmpd.sh
	ln -sf wmpipe_mpd.sh ${BINDIR}/pekmpd.sh
	install -m 755 bin/wmpipe_wp.sh ${BINDIR}
	ln -sf wmpipe_wp.sh ${BINDIR}/icewp.sh
	ln -sf wmpipe_wp.sh ${BINDIR}/obwp.sh
	ln -sf wmpipe_wp.sh ${BINDIR}/pekwp.sh

install: install-sh

.PHONY: install-conf install-libs install-sh install
