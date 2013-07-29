#!/bin/sh
# Sets the background from our $WM menu
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

# Determine which WM we want to format for
case "$(basename $0)" in
pekwp.sh)
  WM=pekwm
;;
icewp.sh)
  WM=icewm
;;
obwp.sh)
  WM=openbox
;;
esac

# Get our canonical prefix and read in functions
PREFIX="$(dirname $(dirname $0))"
. $PREFIX/lib/wmpipe/common.sh
. $PREFIX/lib/wmpipe/$WM.sh

if [ "$WP_ICONS" = "true" ] ; then
 install -d ~/.config/wmpipe/icons
fi

# This function actually creates the menu
create_wp_menu () {
begin_${WM}_pipemenu
for WP in $(find ${WP_DIRS} -type f)
do
NAME=$(basename ${WP} | cut -f 1 -d '.')
if [ "$WP_ICONS" = "true" ] ; then
 ICON="$HOME/.config/wmpipe/icons/${NAME}.png"
fi
create_${WM}_menuentry "$NAME" "$ICON" "$WP_SETCMD '$WP'"
done

if [ "$WP_ICONS" = "true" ] ; then
print_separator
create_${WM}_menuentry "Cache icons" - "$0 cache_icons"
fi
end_${WM}_pipemenu
}

case $1 in
cache_icons)
  for WP in $(find ${WP_DIRS} -type f)
  do
    NAME=$(basename ${WP} | cut -f 1 -d '.')
    convert -resize 64x40 $WP ~/.config/wmpipe/icons/${NAME}.png
  done
;;
*)
  case $WM in
  openbox)
    create_wp_menu | sed 's@&@&amp;@g'
  ;;
  *)
    create_wp_menu
  ;;
  esac
;;
esac
