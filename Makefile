-include config.mk
DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${PREFIX}/etc
BINDIR = ${PREFIX}/bin
LIBDIR = ${PREFIX}/lib/wmpipe
DSHELL = $(shell which bash || which zsh || which ksh)

BIN_OBJS = \
bin/wmpipe_cal.sh \
bin/wmpipe_fb.sh \
bin/wmpipe_mpd.sh \
bin/wmpipe_places.sh \
bin/wmpipe_webmarks.sh \
bin/wmpipe_wp.sh \
bin/wmpipe_appmenu.sh

CAL_LINKS = icecal.sh obcal.sh pekcal.sh
FB_LINKS = icefb.sh obfb.sh pekfb.sh
MPD_LINKS = icempd.sh obmpd.sh pekmpd.sh
PLACES_LINKS = iceplaces.sh obplaces.sh pekplaces.sh
WEBMARK_LINKS = icewebmarks.sh obwebmarks.sh pekwebmarks.sh
WP_LINKS = icewp.sh obwp.sh pekwp.sh
APPMENU_LINKS = iceappmenu.sh obappmenu.sh pekappmenu.sh

ALL_LINKS = \
${CAL_LINKS} \
${FB_LINKS} \
${MPD_LINKS} \
${PLACES_LINKS} \
${WEBMARK_LINKS} \
${WP_LINKS} \
${APPMENU_LINKS}

BIN_ALL_OBJS = ${BIN_OBJS} ${ALL_LINKS}
LIB_OBJS = common.sh icewm.sh openbox.sh pekwm.sh
CONF_OBJS = etc/conf etc/icons.conf

all: config.mk lib/common.sh ${CONF_OBJS} ${BIN_OBJS}
	@echo "Now type \"make install\"."

config.mk:
	echo PREFIX ?= ${PREFIX} > config.mk
	echo SYSCONFDIR ?= ${SYSCONFDIR} >> config.mk

lib/common.sh:
	sed "s%@@SYSCONFDIR@@%${SYSCONFDIR}%" lib/common.sh.in \
		> lib/common.sh

etc/conf:
	if [ "${PUPPY}" = "true" ] ; \
		then cp etc/puppylinux.conf etc/conf ; \
			else cp etc/generic.conf etc/conf ; fi

etc/icons.conf:
	if [ "${PUPPY}" = "true" ] ; \
		then cp etc/puppylinux-icons.conf etc/icons.conf ; \
			else cp etc/generic-icons.conf etc/icons.conf ; fi

$(BIN_OBJS): %.sh: %.sh.in
	sed "s%@@SHELL@@%${DSHELL}%" $< > $@

install-conf: all
	install -d ${DESTDIR}${SYSCONFDIR}/wmpipe
	for obj in ${CONF_OBJS} ; \
		do install -m 644 $${obj} ${DESTDIR}${SYSCONFDIR}/wmpipe ; done

install-libs: install-conf
	install -d ${DESTDIR}${LIBDIR}
	for lib in ${LIB_OBJS} ; \
		do install -m 644 lib/$${lib} ${DESTDIR}${LIBDIR} ; done

install-sh: install-libs
	install -d ${DESTDIR}${BINDIR}
	for bin in ${BIN_OBJS} ; \
		do install -m 755 $${bin} ${DESTDIR}${BINDIR} ; done
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
		do [ -f ${DESTDIR}${PREFIX}/$${obj} ] && \
		unlink ${DESTDIR}${PREFIX}/$${obj} || true ; done
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
	for obj in config.mk lib/common.sh ${CONF_OBJS} ${BIN_OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done

.PHONY: install-conf install-libs install-sh install uninstall-bin \
	uninstall clean
