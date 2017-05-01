#!/bin/sh
# Sets the background from our WM menu
# 06.19.2013 by Nathan Fisher (nfisher dot sr at gmail)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

# Get our canonical prefix and read in functions
SELF="$0"
BINDIR="${SELF%/*}"
PREFIX="${BINDIR%/*}"
. $PREFIX/lib/wmpipe/common.sh

cache=$HOME/.cache/wmpipe/icons
[ -d $cache ] || install -d $cache

[ "$WP_ICONS" = "true" ] && [ ! -d "$HOME/.config/wmpipe/icons" ] && \
  install -d ~/.config/wmpipe/icons

# This function actually creates the menu
create_wp_menu () {
begin_${WM}_pipemenu
while read WP
do NAME=$(basename ${WP} | cut -f 1 -d '.')
[ "$WP_ICONS" = "true" ] && ICON="${cache}/${NAME}.png"
create_${WM}_menuentry "$NAME" "$ICON" "$WP_SETCMD '$WP'"
done <<< "$(find ${WP_DIRS} -type f)"

if [ "$WP_ICONS" = "true" ] ; then
print_separator
create_${WM}_menuentry "Cache icons" - "$0 cache_icons"
fi
end_${WM}_pipemenu
}

case $1 in
cache_icons)
  while read WP
  do NAME=$(basename ${WP} | cut -f 1 -d '.')
    convert -resize 64x40 $WP ${cache}/${NAME}.png
  done <<< "$(find ${WP_DIRS} -type f)"
;;
*)
  case $WM in
  openbox) create_wp_menu | sed 's@&@&amp;@g' ;;
  *) create_wp_menu ;;
  esac
;;
esac
