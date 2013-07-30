DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${DESTDIR}${PREFIX}/etc/wmpipe
BINDIR = $(DESTDIR)${PREFIX}/bin
LIBDIR = $(DESTDIR)${PREFIX}/lib/wmpipe

BIN_OBJS = wmpipe_cal.sh wmpipe_mpd.sh wmpipe_places.sh wmpipe_wp.sh
CAL_LINKS = icecal.sh obcal.sh pekcal.sh
MPD_LINKS = icempd.sh obmpd.sh pekmpd.sh
PLACES_LINKS = iceplaces.sh obplaces.sh pekplaces.sh
WP_LINKS = icewp.sh obwp.sh pekwp.sh
BIN_ALL_OBJS = ${BIN_OBJS} ${CAL_LINKS} ${MPD_LINKS} ${PLACES_LINKS} \
	${WP_LINKS}
LIB_OBJS = common.sh icewm.sh openbox.sh pekwm.sh

all:
	@echo "Just type \"make install\"."
	@echo "Paths can be tuned with DESTDIR and PREFIX variables."

install-conf:
	install -d ${SYSCONFDIR}
	install -m 644 etc/conf ${SYSCONFDIR}
	install -m 644 etc/icons.conf ${SYSCONFDIR}

install-libs: install-conf
	install -d ${LIBDIR}
	for lib in ${LIB_OBJS} ; \
		do install -m 644 lib/$${lib} ${LIBDIR} ; done

install-sh: install-libs
	install -d ${BINDIR}
	for bin in ${BIN_OBJS} ; \
		do install -m 755 bin/$${bin} ${BINDIR} ; done
	for link in ${CAL_LINKS} ; \
		do ln -sf wmpipe_cal.sh ${BINDIR}/$${link} ; done
	for link in ${MPD_LINKS} ; \
		do ln -sf wmpipe_mpd.sh ${BINDIR}/$${link} ; done
	for link in ${PLACES_LINKS} ; \
		do ln -sf wmpipe_places.sh ${BINDIR}/$${link} ; done
	for link in ${WP_LINKS} ; \
		do ln -sf wmpipe_wp.sh ${BINDIR}/$${link} ; done

install: install-sh

uninstall-bin:
	for obj in ${BIN_ALL_OBJS} ; \
		do rm -rf ${BINDIR}/$${obj} ; done

uninstall: uninstall-bin
	for obj in ${LIB_OBJS} ; \
		do rm -rf ${LIBDIR}/$${obj} ; done
	rm -f ${SYSCONFDIR}/conf
	rm -f ${SYSCONFDIR}/icons.conf

.PHONY: install-conf install-libs install-sh install uninstall-bin \
	uninstall
