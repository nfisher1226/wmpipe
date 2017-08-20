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
SELF="$0"
BINDIR="${SELF%/*}"
PREFIX="${BINDIR%/*}"
. $PREFIX/lib/wmpipe/common.sh

dwb_bmks () {
  if [[ -f "$HOME/.config/dwb/default/bookmarks" ]] ; then
    print_separator DWB
    while read bm
    do name=$(cut -f 2- -d ' ' <<< $bm)
      url=$(cut -f 1 -d ' ' <<< $bm)
      create_${WM}_menuentry "$(rev <<< $name)" - "dwb $(rev <<< $url)"
    done <<< $(rev $HOME/.config/dwb/default/bookmarks)
  fi
}

qutebrowser_bmks () {
  if [[ -f "$HOME/.config/qutebrowser/quickmarks" ]] ; then
    print_separator Qutebrowser
    while read bm
    do name=$(cut -f 2- -d ' ' <<< $bm)
      url=$(cut -f 1 -d ' ' <<< $bm)
      create_${WM}_menuentry "$(rev <<< $name) - $(rev <<< $url)" - "qutebrowser $(rev <<< $url)"
    done <<< $(rev $HOME/.config/qutebrowser/quickmarks)
  fi
  if [[ -f "$HOME/.config/qutebrowser/bookmarks/urls" ]] ; then
    while read bm
    do name="$(cut -f 2- -d ' ' <<< $bm | cut -b 1-50)"
      url="$(cut -f 1 -d ' ' <<< $bm)"
      create_${WM}_menuentry "${name}" - "qutebrowser ${url}"
    done < $HOME/.config/qutebrowser/bookmarks/urls
  fi
}

midori_bmks () {
  DIR=$HOME/.config/midori/
  if [ -f "$DIR/bookmarks_v2.db" ]
    then BDB=$DIR/bookmarks_v2.db
  elif [ -f "$DIR/bookmarks.db" ]
    then BDB=$DIR/bookmarks.db
  fi
  if [[ ! -z $BDB ]] ; then
    print_separator Midori
    while read URI
      do FIXEDURI=$(sed "s%'%''%g" <<< "$URI")
      TITLE="$(sqlite3 $BDB "select title from bookmarks where uri='$FIXEDURI'")"
      create_${WM}_menuentry "$TITLE" "-" "midori $URI"
    done <<< "$(sqlite3 $BDB 'select uri from bookmarks')"
  fi
}

begin_${WM}_pipemenu
dwb_bmks
qutebrowser_bmks
midori_bmks
end_${WM}_pipemenu
