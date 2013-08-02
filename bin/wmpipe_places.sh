#!/bin/bash
# Simple places script for your WM menu
# 06.20.2013 by Nathan Fisher (nfisher dot sr at gmail)
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
PREFIX="$(dirname $(dirname $0))"
. $PREFIX/lib/wmpipe/common.sh

# Create our menu with this function
create_places_menu () {
begin_${WM}_pipemenu
[ "$WM" = "openbox" ] && print_separator Places
# Static places menu
create_${WM}_menuentry "Filesystem" "$DRIVE_ICON" "$FILEMANAGER /"
if [ "$BROWSE_HOME" = "true" ] ; then
  open_${WM}_pipemenu "Home" "${ABBR}fb.sh '$HOME'" "$HOME_ICON" 0
else
  create_${WM}_menuentry "Home" "$HOME_ICON" "$FILEMANAGER $HOME"
fi

case $FILEMANAGER in
rox)
  if [ -d "$HOME/.trash" ] ; then
    create_${WM}_menuentry "Trash" "$TRASH_ICON" "$FILEMANAGER $HOME/.trash"
  fi
;;
nautilus|thunar)
  create_${WM}_menuentry "Trash" "$TRASH_ICON" "$FILEMANAGER trash:///"
  create_${WM}_menuentry "Network" "${NETWORK_ICON}" "$FILEMANAGER network:///"
;;
pcmanfm)
  create_${WM}_menuentry "Trash" "$TRASH_ICON" "$FILEMANAGER trash:///"
;;
esac


# Catch any removable devices mounted in /media
if [ ! "$(mount | grep '/media/')" = "" ] ; then
 print_separator Removable
 for removable in $(mount | grep '/media/' | cut -f 3 -d ' ')
  do
  create_${WM}_menuentry "$(basename $removable)" "$FOLDER_ICON" "$FILEMANAGER ${removable}"
 done
fi

# gtk bookmarks
print_separator "Gtk Bookmarks"
while read bookmark
do
  SETNAME="$(echo $bookmark | cut -s -f 2- -d ' ')"
  if [ ! "$SETNAME" = "" ] ; then
    LABEL="$SETNAME"
    bookmark="$(echo $bookmark | cut -f 1 -d ' ' | sed 's/%20/ /')"
  else
    LABEL="$(basename $bookmark | sed 's/%20/ /')"
  fi
  create_${WM}_menuentry "$LABEL" "$FOLDER_ICON" "$FILEMANAGER '${bookmark}'"
done<$HOME/.gtk-bookmarks

# rox bookmarks
# first, see if there actually are any
[ ! -f "$HOME/.config/rox.sourceforge.net/ROX-Filer/Bookmarks.xml" ] && \
  ROX_BM=false
if [ "$ROX_BM" = "true" ] ; then
  print_separator "Rox-Filer bookmarks"
  sed -e '/bookmark title=/!d' -e 's%  <bookmark title="%%g' \
  -e 's%">%|%g' -e 's%</bookmark>%%g' \
    ~/.config/rox.sourceforge.net/ROX-Filer/Bookmarks.xml | \
  while read LINE ; do
    label="$(echo $LINE | cut -f 1 -d '|')"
    bookmark="$(echo $LINE | cut -f 2 -d '|')"
    create_${WM}_menuentry "$label" "$FOLDER_ICON" "$FILEMANAGER '${bookmark}'"
  done
fi

print_separator Recent
begin_${WM}_submenu "Recent" "$OPEN_DOC_ICON" "RECENT"
grep "href=\"file" ${HOME}/.local/share/recently-used.xbel | \
  tail -n 10 | cut -f 2 -d '"' | sed 's%file://%%' | while read uri ; do
  if [ -f "${uri}" ]; then
    PROG="$(basename ${uri})"
  else
    PROG="* $(basename ${uri})"
  fi
  create_${WM}_menuentry "$PROG" "$FILE_ICON" "$FILE_HANDLER '${uri}'"
done

print_separator
create_${WM}_menuentry "Clear Recent Documents" "$CLEAR_ICON" "echo > ${HOME}/.local/share/recently-used.xbel"
end_${WM}_submenu
end_${WM}_pipemenu
}

case $WM in
openbox)
  create_places_menu | sed 's@&@&amp;@g'
;;
*)
  create_places_menu
;;
esac

