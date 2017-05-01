#!/bin/sh
# Creates an applications menu using .desktop files to find only the
# applications installed on your system. The generated menu is functional
# but is not xdg compliant, as .directory and menu files are ignored and
# the menu is laid out according to how the script feels fit.
#
# This script is quite slow on first run but is lightning fast after that
# for use in pipe menus. It uses caching to only rebuild the menu if 
# something has changed in /usr/share/applications.
#
# 04.30.2017 by Nathan Fisher (nfisher dot sr at gmail)
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

cache=$HOME/.cache/wmpipe/xdg
if [ /usr/share/applications -nt $cache ]
  then [ -d $cache ] || install -d $cache
  rm -rf ${cache}/*
  apps=$(grep 'Type=Application' /usr/share/applications/* | cut -f 1 -d ':')
  while read app
  do cts=$(grep Categories= $app)
    if [ ! $(egrep "Development|TextEditor"<<<$cts) = "" ]
      then echo $(basename ${app}) >> ${cache}/dev
    elif [ ! "$(grep Graphics<<<$cts)" = "" ]
      then echo $(basename ${app}) >> ${cache}/gph
    elif [ ! $(egrep "Multimedia|Audio|Video"<<<$cts) = "" ]
      then echo $(basename ${app}) >> ${cache}/mmd
    elif [ ! "$(grep Network<<<$cts)" = "" ]
      then echo $(basename ${app}) >> ${cache}/net
    elif [ ! "$(grep Settings<<<$cts)" = "" ]
      then echo $(basename ${app}) >> ${cache}/set
    elif [ ! "$(grep System<<<$cts)" = "" ]
      then echo $(basename ${app}) >> ${cache}/sys
    fi
    if [ ! -f ${cache}/$(basename ${app}) ]
      then egrep -m 3 "^Name=|^Icon=|^Exec=" $app \
      | sed -e 's%Name=%Name="%g' -e 's%Icon=%Icon="%g' -e 's%Exec=%Exec="%g' \
      -e s/$/\"/ > ${cache}/$(basename ${app})
      . ${cache}/$(basename ${app})
      echo Icon=$(find /usr/share/icons/*/16x16 /usr/share/pixmaps \
        -name ${Icon}.png | head -n 1) >> ${cache}/$(basename ${app})
    fi
  done<<<$apps
fi

begin_${WM}_pipemenu

begin_${WM}_submenu "Development" "$CATEGORY_DEV_ICON" "DEVELOPMENT"
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/applications-development.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_dev}" ${cache}/dev)
end_${WM}_submenu

echo '  Submenu = "Graphics" {'
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/applications-graphics.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_gph}" ${cache}/gph)
end_${WM}_submenu

echo '  Submenu = "Multimedia" {'
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/applications-multimedia.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_mmd}" ${cache}/mmd)
end_${WM}_submenu

echo '  Submenu = "Network" {'
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/applications-internet.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_net}" ${cache}/net)
end_${WM}_submenu

echo '  Submenu = "Settings" {'
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/preferences-system.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_set}" ${cache}/set)
end_${WM}_submenu

echo '  Submenu = "System" {'
echo '  Icon = "/usr/share/icons/gnome/16x16/categories/applications-system.png"'
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<< $(egrep -v "${exclude_sys}" ${cache}/sys)
end_${WM}_submenu

end_${WM}_pipemenu
