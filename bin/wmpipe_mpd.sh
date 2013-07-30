#!/bin/sh
# Control mpc/mpd from our WM menu
# 06.20.2013 by Nathan Fisher (nfisher dot sr at gmail)
#
# There exist already a few such scripts, many of which work quite well.
# However, none that I am aware of are written as simple shell scripts,
# most use Python. I'm writing this for those who want this type of
# functionality on a more cutdown system that may not have higher level
# interpreters available.
#
# This script, in comparison, requires only mpd, mpc, and a bourne
# compatible shell. It's also useful to have another client program
# installed so we can launch it from this menu.
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
. $PREFIX/lib/wmpipe/$WM.sh

export MPD_HOST MPD_PORT MPD_CLIENT

REPEAT_STATUS=$(mpc | tail -n 1 | cut -f 3 -d ':' | cut -f 2 -d ' ')
RANDOM_STATUS=$(mpc | tail -n 1 | cut -f 4 -d ':' | cut -f 2 -d ' ')
[ "$MPD_CLIENT_TERMINAL" = "true" ] && TERMCMD="$TERMINAL -e "

mpd_playbutton () {
  create_${WM}_menuentry "Play" "$PLAY_ICON" "mpc play"
}
mpd_pausebutton () {
  create_${WM}_menuentry "Pause" "$PAUSE_ICON" "mpc pause"
}
mpd_stopbutton () {
  create_${WM}_menuentry "Stop" "$STOP_ICON" "mpc stop"
}
mpd_otherbuttons () {
  create_${WM}_menuentry "Previous" "$PREV_ICON" "mpc prev"
  create_${WM}_menuentry "Next" "$NEXT_ICON" "mpc next"
  print_separator
  create_${WM}_menuentry "Toggle Repeat" "$REPEAT_ICON" "mpc repeat"
  create_${WM}_menuentry "Toggle Random" "$RANDOM_ICON" "mpc random"
}

MPD_CURRENT=$(mpc current)
if [ "$MPD_CURRENT" = "" ] ; then
 MPD_MSG="Stopped"
 MPD_STATE=stopped
 MPD_ICON="$STOP_ICON"
else
 if [ "$(mpc | grep 'paused')" = "" ] ; then
  MPD_STATE=playing
  MPD_ICON="$PLAY_ICON"
 else
  MPD_STATE=paused
  MPD_ICON="$PAUSE_ICON"
 fi
 MPD_MSG="$MPD_CURRENT [$MPD_STATE]"
fi

# Actually print the menu with this function
create_mpd_menu () {
begin_${WM}_pipemenu
create_${WM}_menuentry "$MPD_MSG" "$MPD_ICON" "${TERMCMD}${MPD_CLIENT}"
print_separator
# Volume submenu
begin_${WM}_submenu "$(mpc volume | sed 's/ 0%/ [muted]/')" "$VOLUME_ICON"
create_${WM}_menuentry "100%" - "mpc volume 100"
create_${WM}_menuentry "85%" - "mpc volume 85"
create_${WM}_menuentry "70%" - "mpc volume 70"
create_${WM}_menuentry "55%" - "mpc volume 55"
create_${WM}_menuentry "40%" - "mpc volume 40"
create_${WM}_menuentry "25%" - "mpc volume 25"
create_${WM}_menuentry "15%" - "mpc volume 15"
print_separator
create_${WM}_menuentry "mute" "$MUTE_ICON" "mpc volume 0"
end_${WM}_submenu
# Playlists submenu
begin_${WM}_submenu "Playlist" "$FILE_ICON"
mpc lsplaylists | while read playlist
do
 create_${WM}_menuentry "$playlist" - "mpc load ${playlist}"
done
print_separator
create_${WM}_menuentry "Clear" "$CLEAR_ICON" "mpc clear"
end_${WM}_submenu
# Show our controls
case $MPD_STATE in
stopped)
 mpd_playbutton
;;
playing)
 mpd_pausebutton
 mpd_stopbutton
 mpd_otherbuttons
;;
paused)
 mpd_playbutton
 mpd_otherbuttons
;;
esac
print_separator
create_${WM}_menuentry "Update Database" "$REFRESH_ICON" "mpc refresh"
end_${WM}_pipemenu
}

case $WM in
openbox)
  create_mpd_menu | sed 's@&@&amp;@g'
;;
*)
  create_mpd_menu
;;
esac
