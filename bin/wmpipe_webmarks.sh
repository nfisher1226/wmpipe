#!/bin/sh
#
#  wmpipe_webmarks.sh
#
#  Copyright 2013 Nathan Fisher <nfisher.sr@gmail.com>
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
#

# Get our canonical prefix and read in functions
PREFIX="$(dirname $(dirname $0))"
. $PREFIX/lib/wmpipe/common.sh

dwb_bmks () {
  begin_${WM}_submenu "DWB" "/usr/share/pixmaps/dwb.png"
  while read bm
  do name="$(echo $bm | cut -f 2- -d ' ')"
    url="$(echo $bm | cut -f 1 -d ' ')"
    create_${WM}_menuentry "$name" - "dwb $url"
  done<$HOME/.config/dwb/default/bookmarks
  end_${WM}_submenu
}

midori_bmks () {
  DIR=$HOME/.config/midori/
  if [ -f "$DIR/bookmarks_v2.db" ]
    then BDB=$DIR/bookmarks_v2.db
  elif [ -f "$DIR/bookmarks.db" ]
    then BDB=$DIR/bookmarks.db
  fi
  if [[ ! -z $BDB ]] ; then
    begin_${WM}_submenu "Midori" "/usr/share/icons/hicolor/16x16/apps/midori.png"
    sqlite3 $BDB 'select uri from bookmarks' | \
    while read URI
      do FIXEDURI=$(sed "s%'%''%g" <<< "$URI")
      TITLE="$(sqlite3 $BDB "select title from bookmarks where uri='$FIXEDURI'")"
      create_${WM}_menuentry "$TITLE" "-" "midori $URI"
    done
    end_${WM}_pipemenu
  fi
}

begin_${WM}_pipemenu
dwb_bmks
midori_bmks
end_${WM}_pipemenu
