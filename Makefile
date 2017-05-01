-include config.mk
DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${PREFIX}/etc
BINDIR = ${PREFIX}/bin
LIBDIR = ${PREFIX}/lib/wmpipe

BIN_OBJS = wmpipe_cal.sh wmpipe_fb.sh wmpipe_mpd.sh wmpipe_places.sh \
	wmpipe_webmarks.sh wmpipe_wp.sh wmpipe_appmenu.sh
CAL_LINKS = icecal.sh obcal.sh pekcal.sh
FB_LINKS = icefb.sh obfb.sh pekfb.sh
MPD_LINKS = icempd.sh obmpd.sh pekmpd.sh
PLACES_LINKS = iceplaces.sh obplaces.sh pekplaces.sh
WEBMARK_LINKS = icewebmarks.sh obwebmarks.sh pekwebmarks.sh
WP_LINKS = icewp.sh obwp.sh pekwp.sh
APPMENU_LINKS = iceappmenu.sh obappmenu.sh pekappmenu.sh
ALL_LINKS= ${CAL_LINKS} ${FB_LINKS} ${MPD_LINKS} ${PLACES_LINKS} \
	${WEBMARK_LINKS} ${WP_LINKS} ${APPMENU_LINKS}
BIN_ALL_OBJS = ${BIN_OBJS} ${ALL_LINKS}
LIB_OBJS = common.sh icewm.sh openbox.sh pekwm.sh
CONF_OBJS = etc/conf etc/icons.conf

all: lib/common.sh config.mk ${CONF_OBJS}
	@echo "Now type \"make install\"."

etc/conf:
	if [ "${PUPPY}" = "true" ] ; \
		then cp etc/puppylinux.conf etc/conf ; \
			else cp etc/generic.conf etc/conf ; fi
etc/icons.conf:
	if [ "${PUPPY}" = "true" ] ; \
		then cp etc/puppylinux-icons.conf etc/icons.conf ; \
			else cp etc/generic-icons.conf etc/icons.conf ; fi

config.mk:
	echo PREFIX ?= ${PREFIX} > config.mk
	echo SYSCONFDIR ?= ${SYSCONFDIR} >> config.mk

lib/common.sh:
	sed "s%@@SYSCONFDIR@@%${SYSCONFDIR}%" lib/common.sh.in \
		> lib/common.sh

install-conf: all
	install -d ${DESTDIR}${SYSCONFDIR}/wmpipe
	install -m 644 etc/conf ${DESTDIR}${SYSCONFDIR}/wmpipe
	install -m 644 etc/icons.conf ${DESTDIR}${SYSCONFDIR}/wmpipe

install-libs: install-conf
	install -d ${DESTDIR}${LIBDIR}
	for lib in ${LIB_OBJS} ; \
		do install -m 644 lib/$${lib} ${DESTDIR}${LIBDIR} ; done

install-sh: install-libs
	install -d ${DESTDIR}${BINDIR}
	for bin in ${BIN_OBJS} ; \
		do install -m 755 bin/$${bin} ${DESTDIR}${BINDIR} ; done
	for link in ${CAL_LINKS} ; \
		do ln -sf wmpipe_cal.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${FB_LINKS} ; \
		do ln -sf wmpipe_fb.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${MPD_LINKS} ; \
		do ln -sf wmpipe_mpd.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${PLACES_LINKS} ; \
		do ln -sf wmpipe_places.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${WEBMARK_LINKS} ; \
		do ln -sf wmpipe_webmarks.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${WP_LINKS} ; \
		do ln -sf wmpipe_wp.sh ${DESTDIR}${BINDIR}/$${link} ; done
	for link in ${APPMENU_LINKS} ; \
		do ln -sf wmpipe_appmenu.sh ${DESTDIR}${BINDIR}/$${link} ; done

install: all install-sh

uninstall-bin:
	for obj in ${BIN_OBJS} ; \
		do [ -f ${DESTDIR}${BINDIR}/$${obj} ] && \
		unlink ${DESTDIR}${BINDIR}/$${obj} || true ; done
	for link in ${ALL_LINKS} ; \
		do [ -L ${DESTDIR}${BINDIR}/$${link} ] && \
		unlink ${DESTDIR}${BINDIR}/$${link} || true ; done

uninstall: uninstall-bin
	for obj in ${LIB_OBJS} ; \
		do [ -f ${DESTDIR}${LIBDIR}/$${obj} ] && \
		unlink ${DESTDIR}${LIBDIR}/$${obj} || true ; done
	[ -f ${DESTDIR}${SYSCONFDIR}/wmpipe/conf ] && \
		unlink ${DESTDIR}${SYSCONFDIR}/wmpipe/conf || true
	[ -f ${DESTDIR}${SYSCONFDIR}/wmpipe/icons.conf ] && \
		unlink ${DESTDIR}${SYSCONFDIR}/wmpipe/icons.conf || true

clean:
	for obj in config.mk lib/common.sh ${CONF_OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done

.PHONY: install-conf install-libs install-sh install uninstall-bin \
	uninstall clean
