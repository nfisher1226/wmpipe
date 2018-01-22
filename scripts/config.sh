#!/bin/sh

case $(uname -s) in
*Linux*)
  if [ -x "/usr/pkg/bmake" ] # Linux pkgsrc
    then echo PREFIX = /usr/pkg > config.mk
    echo SYSCONFDIR = /etc/wmpipe >> config.mk
  elif [ -f "/etc/DISTRO_SPECS" ] && \
    [ ! "$(egrep "puppy|Puppy" /etc/DISTRO_SPECS)" = "" ]
    then echo PREFIX = /usr > config.mk
    echo SYSCONFDIR = /etc/wmpipe >> config.mk
    echo PUPPY = true >> config.mk
  else echo PREFIX = /usr > config.mk
    echo SYSCONFDIR = /etc/wmpipe >> config.mk
  fi
;;
*FreeBSD*)
  echo PREFIX = /usr/local > config.mk
  echo SYSCONFDIR = /usr/local/etc/etc/wmpipe >> config.mk
;;
*NetBSD*)
  echo PREFIX = /usr/pkg > config.mk
  echo SYSCONFDIR = /usr/pkg/etc/wmpipe >> config.mk
;;
esac
