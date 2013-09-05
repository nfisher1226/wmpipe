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

# If no arguments or args aren't a directory just exit
dir="$@"
[ -d "$dir" ] || exit 1

# Get our canonical prefix and read in functions
SELF="$0"
BINDIR="${SELF%/*}"
PREFIX="${BINDIR%/*}"
. $PREFIX/lib/wmpipe/common.sh

open_term_here () {
[ -d "$dir" ] && cd "$dir" && exec $TERMINAL
}

bookmark_directory () {
echo "file://${dir}" >> $HOME/.gtk-bookmarks
}

dirs="$(find "$dir" -maxdepth 1 -mindepth 1 -type d ! -name '.*')"
files="$(find "$dir" -maxdepth 1 -mindepth 1 -type f ! -name '.*')"
dotdirs="$(find "$dir" -maxdepth 1 -mindepth 1 -type d -name '.*')"
dotfiles="$(find "$dir" -maxdepth 1 -mindepth 1 -type f -name '.*')"

create_fb_menu () {
begin_${WM}_pipemenu
if [ ! "$dir" = "/" ] ; then
  PARENT="${dir%/*}"
  [ "$PARENT" = "" ] && PARENT=/
  [ "$WM" = "openbox" ] && print_separator "$PARENT"
  open_${WM}_pipemenu "$PARENT" "$SELF '$PARENT'" "$FOLDER_ICON" 0
  print_separator "$dir"
else
  [ "$WM" = "openbox" ] && print_separator "$dir"
fi

create_${WM}_menuentry "$dir filemanager" "$FILEMANAGER_ICON" "$FILEMANAGER '$dir'"
create_${WM}_menuentry "$dir terminal" "$TERMINAL_ICON" "$SELF --term '$dir'"
create_${WM}_menuentry "Bookmark $dir" "$BOOKMARK_ICON" "$SELF --bookmark '$dir'"

if [ ! "$dotdirs" = "" ] && \
  [ ! "$dotfiles" = "" ] ; then
  begin_${WM}_submenu "hidden" "$FOLDER_ICON" "HIDDEN"

  if [ ! "$dotdirs" = "" ] ; then
    [ "$WM" = "openbox" ] && print_separator Directories
    while read d
    do
      open_${WM}_pipemenu "${d##*/}" "$SELF '$d'" "$FOLDER_ICON" 0
    done <<< "$(sort <<< "$dotdirs")"
  fi

  if [ ! "$dotfiles" = "" ] ; then
    [ "$WM" = "openbox" ] && print_separator Files
    while read f
    do
      create_${WM}_menuentry "${f##*/}" "$FILE_ICON" "$FILE_HANDLER '$FILE'"
    done <<< "$(sort <<< "$dotfiles")"
  fi
  end_${WM}_submenu
fi

if [ ! "$dirs" = "" ] ; then
  print_separator Directories
  while read d
  do
    open_${WM}_pipemenu "${d##*/}" "$SELF '$d'" "$FOLDER_ICON" 0
  done <<< "$(sort <<< "$dirs")"
fi

if [ ! "$files" = "" ] ; then
  print_separator Files
  while read f
  do
    create_${WM}_menuentry "${f##*/}" "$FILE_ICON" "$FILE_HANDLER '$f'"
  done <<< "$(sort <<< "$files")"
fi
end_${WM}_pipemenu
}

case $WM in
openbox)
  create_fb_menu "$dir" | sed 's@&@&amp;@g'
;;
*)
  create_fb_menu "$dir"
;;
esac
