#!/bin/sh
#
#  wmpie_fb.sh - written 08.01.2013
#  Creates a brows-able menu of directory contents in your WM menu
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

self="$0"
DIR="$1"
INODE="$(stat -tc %i "$DIR")"
FB_CACHE="$HOME/.config/wmpipe/fb_cache"
DIRS_FILE="$FB_CACHE/${INODE}.dirs"
FILES_FILE="$FB_CACHE/${INODE}.files"
DOTDIRS_FILE="$FB_CACHE/${INODE}.dotdirs"
DOTFILES_FILE="$FB_CACHE/${INODE}.dotfiles"
[ ! -d "$FB_CACHE" ] && install -d "$FB_CACHE"
[ ! -f "$FB_CACHE/directory" ] && touch "$FB_CACHE/directory"

open_term_here () {
[ -d "$1" ] && cd "$1" && exec $TERMINAL
}

bookmark_directory () {
echo "file://${1}" >> $HOME/.gtk-bookmarks
}

create_fb_menu () {
DIR="$1"
[ "$DIR" = "" ] && DIR=/
begin_${WM}_pipemenu
PARENT="$(dirname $DIR)"
if [ ! "$DIR" = "$PARENT" ] ; then
  [ "$WM" = "openbox" ] && print_separator "Parent"
  open_${WM}_pipemenu "$PARENT" "$self '$PARENT'" "$FOLDER_ICON" 0
  print_separator "$DIR"
else
  [ "$WM" = "openbox" ] && print_separator "$DIR"
fi

create_${WM}_menuentry "$DIR filemanager" "$FILEMANAGER_ICON" "$FILEMANAGER '$DIR'"
create_${WM}_menuentry "$DIR terminal" "$TERMINAL_ICON" "$self --term '$DIR'"
create_${WM}_menuentry "Bookmark $DIR" "$BOOKMARK_ICON" "$self --bookmark '$DIR'"

if [ ! "$(head -n 1 $DOTDIRS_FILE)" = "" ] && \
  [ ! "$(head -n 1 $DOTFILES_FILE)" = "" ] ; then
  begin_${WM}_submenu "hidden" "$FOLDER_ICON"

  if [ ! "$(head -n 1 $DOTDIRS_FILE)" = "" ] ; then
    [ "$WM" = "openbox" ] && print_separator Directories
    cat $DOTDIRS_FILE | while read SUBDIR
    do
      NEWPIPE="$(basename "$SUBDIR")"
      open_${WM}_pipemenu "$NEWPIPE" "$self '$SUBDIR'" "$FOLDER_ICON" 0
    done
  fi

  if [ ! "$(head -n 1 $DOTFILES_FILE)" = "" ] ; then
    [ "$WM" = "openbox" ] && print_separator Files
    cat $DOTFILES_FILE | while read FILE
    do
      NAME="$(basename "$FILE")"
      create_${WM}_menuentry "$NAME" "$FILE_ICON" "$FILE_HANDLER '$FILE'"
    done
  fi
  end_${WM}_submenu
fi

if [ ! "$(head -n 1 $DIRS_FILE)" = "" ] ; then
  print_separator Directories
  cat $DIRS_FILE | while read SUBDIR
  do
    NEWPIPE="$(basename "$SUBDIR")"
    open_${WM}_pipemenu "$NEWPIPE" "$self '$SUBDIR'" "$FOLDER_ICON" 0
  done
fi

if [ ! "$(head -n 1 $FILES_FILE)" = "" ] ; then
  print_separator Files
  find "$DIR" -maxdepth 1 -mindepth 1 -type f ! -name '.*'  | sort | while read FILE
  do
    NAME="$(basename "$FILE")"
    create_${WM}_menuentry "$NAME" "$FILE_ICON" "$FILE_HANDLER '$FILE'"
  done
fi
end_${WM}_pipemenu
}

cache_menu () {
DIR="$1"
MENU="${FB_CACHE}/${INODE}-${WM}.menu"
CACHED_MTIME="$2"
MTIME="$3"
TEMPFILE="$(mktemp)"
find "$DIR" -maxdepth 1 -mindepth 1 -type d ! -name '.*'  | sort > \
  "$DIRS_FILE"
find "$DIR" -maxdepth 1 -mindepth 1 -type f ! -name '.*'  | sort > \
  "$FILES_FILE"
find "$DIR" -maxdepth 1 -mindepth 1 -type d -name '.*'  | sort > \
  "$DOTDIRS_FILE"
find "$DIR" -maxdepth 1 -mindepth 1 -type f -name '.*'  | sort > \
  "$DOTFILES_FILE"
case $WM in
openbox)
  create_fb_menu "$DIR" | sed 's@&@&amp;@g' | tee "$MENU"
;;
*)
  create_fb_menu "$DIR" | tee "$MENU"
;;
esac
touch $HOME/.config/wmpipe/fb_cache/directory
grep -v "|${DIR}|" "$FB_CACHE/directory" > $TEMPFILE
echo "|${DIR}|${INODE}|${MTIME}" >> $TEMPFILE
mv $TEMPFILE "$FB_CACHE/directory"
}

case "$1" in
--term)
  open_term_here "$2"
;;
--bookmark)
  [ -d "$2" ] && bookmark_directory "$2"
;;
*)
  if [ -d "$1" ] ; then
    DIR="$1"
    [ ! -d "$FB_CACHE/directory" ] && \
      install -d "$FB_CACHE/directory"
    touch "$FB_CACHE/directory"
    DIR="$1"
    MTIME="$(stat -tc %y "$DIR")"
    CACHED_MTIME="$(grep "|${INODE}|" "$FB_CACHE/directory" \
      | cut -f 4 -d '|')"
    if [ ! "$MTIME" = "$CACHED_MTIME" ] ; then
      cache_menu "$DIR" "$CACHED_MTIME" "$MTIME"
    else
      cat ${FB_CACHE}/${INODE}-${WM}.menu
    fi
  fi
;;
esac
