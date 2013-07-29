#!/bin/sh
#
# pekdate.sh
#
# Ported to wmpipe from date-menu.sh, an openbox pipe menu.
# Original comments follow.
#
# date-menu.sh
#
# This is in the public domain.  Honestly, how can you claim anything to something
# this simple?
#
# Outputs a simple openbox pipe menu to display the date, time, and calendar.
# You need 'date' and 'cal'.  You should have these.  Additionally, the calendar
# only appears properly formated if you use a mono spaced font.

# Outputs the selected row from the calender output.
# If you don't use a mono spaced font, you would have to play with spacing here.
# It would probably involve a very complicated mess.  Is there a way to force a
# different font per menu?

# Determine which WM we want to format for
case "$(basename $0)" in
pekcal.sh)
  WM=pekwm
;;
icecal.sh)
  WM=icewm
;;
obcal.sh)
  WM=openbox
;;
esac

# Get our canonical prefix and read in functions
PREFIX="$(dirname $(dirname $0))"
. $PREFIX/lib/wmpipe/common.sh
. $PREFIX/lib/wmpipe/$WM.sh

# Make sure the $CALENDAR var isn't empty
[ "$CALENDAR" = "" ] && CALENDAR=true

function calRow() {
  cal | gawk -v row=$1 '{ if (NR==row) { print $0 } }'
}

# Build the menu
begin_${WM}_pipemenu
create_${WM}_menuentry "$(date +%A\ \ \ \ \ \ %I\:%M\ %p)" - "$CALENDAR"
create_${WM}_menuentry "$(date +%B\ %d,\ %Y)" "$CALENDAR"
print_separator
create_${WM}_menuentry "$(calRow 2)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 3)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 4)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 5)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 6)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 7)" - "$CALENDAR"
create_${WM}_menuentry "$(calRow 8)" - "$CALENDAR"
end_${WM}_pipemenu

