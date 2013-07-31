#!/bin/sh

case $(uname -s) in
*Linux*)
  if [ -x "/usr/pkg/bmake" ] ; then # Linux pkgsrc
    echo PREFIX ?= /usr/pkg > config.mk
    echo SYSCONFDIR = \${PREFIX}/etc/wmpipe >> config.mk
    install -m 644 etc/generic.conf etc/conf
    install -m 644 etc/generic-icons.conf etc/icons.conf
  elif [ -f "/etc/DISTRO_SPECS" ] && \
    [ ! "$(egrep "puppy|Puppy" /etc/DISTRO_SPECS)" = "" ] ; then
    echo PREFIX ?= /usr > config.mk
    echo SYSCONFDIR = /etc/wmpipe >> config.mk
    install -m 644 etc/puppylinux.conf etc/conf
    install -m 644 etc/puppylinux.icons etc/icons.conf
  else
    echo PREFIX ?= /usr > config.mk
    echo SYSCONFDIR = /etc/wmpipe >> config.mk
    install -m 644 etc/generic.conf etc/conf
    install -m 644 etc/generic-icons.conf etc/icons.conf
  fi
;;
*FreeBSD*)
  echo PREFIX ?=/usr/local > config.mk
  echo SYSCONFDIR = \${PREFIX}/etc/wmpipe >> config.mk
  install -m 644 etc/generic.conf etc/conf
  install -m 644 etc/generic-icons.conf etc/icons.conf
;;
*NetBSD*)
  echo PREFIX ?= /usr/pkg > config.mk
  echo SYSCONFDIR = \${PREFIX}/etc/wmpipe >> config.mk
  install -m 644 etc/generic.conf etc/conf
  install -m 644 etc/generic-icons.conf etc/icons.conf
;;
esac
