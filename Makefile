DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${DESTDIR}${PREFIX}/etc/wmpipe
BINDIR = $(DESTDIR)${PREFIX}/bin
LIBDIR = $(DESTDIR)${PREFIX}/lib/wmpipe

all:
	@echo "Just type \"make install\"."
	@echo "Paths can be tuned with DESTDIR and PREFIX variables."

install-conf:
	install -d ${SYSCONFDIR}
	install -m 644 etc/conf ${SYSCONFDIR}
	install -m 644 etc/icons.conf ${SYSCONFDIR}

install-libs: install-conf
	install -d ${LIBDIR}
	install -m 644 lib/common.sh ${LIBDIR}
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
	install -m 755 bin/wmpipe_cal.sh ${BINDIR}
	ln -sf wmpipe_cal.sh ${BINDIR}/icecal.sh
	ln -sf wmpipe_cal.sh ${BINDIR}/obcal.sh
	ln -sf wmpipe_cal.sh ${BINDIR}/pekcal.sh

install: install-sh

uninstall:
	unlink ${BINDIR}/wmpipe_mpd.sh
	unlink ${BINDIR}/icempd.sh
	unlink ${BINDIR}/obmpd.sh
	unlink ${BINDIR}/pekmpd.sh
	unlink ${BINDIR}/wmpipe_wp.sh
	unlink ${BINDIR}/icewp.sh
	unlink ${BINDIR}/obwp.sh
	unlink ${BINDIR}/pekwp.sh
	unlink ${BINDIR}/wmpipe_cal.sh
	unlink ${BINDIR}/icecal.sh
	unlink ${BINDIR}/obcal.sh
	unlink ${BINDIR}/pekcal.sh
	unlink ${LIBDIR}/common.sh
	unlink ${LIBDIR}/icewm.sh
	unlink ${LIBDIR}/openbox.sh
	unlink ${LIBDIR}/pekwm.sh
	unlink ${SYSCONFDIR}/conf
	unlink ${SYSCONFDIR}/icons.conf

.PHONY: install-conf install-libs install-sh install uninstall
