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
# Setup our cache if it doesn't exist or is out of date
if [ /usr/share/applications -nt $cache ] ; then
  if [ -d $cache ] ; then
    # Remove any stale entries
    ls -1 ${cache}/*.desktop | while read app ; do
      if [ ! -f /usr/share/applications/$(basename ${app}) ] ; then
        rm -rf ${app}
        app=$(basename ${app})
        sed -i "/$app/ d" ${cache}/dev ${cache}/gph ${cache}/mmd \
          ${cache}/net ${cache}/set ${cache}/sys
      fi
    done
  else
    # Create the cache if it doesn't exist
    install -d $cache
  fi
  # only want .desktop files of type "Application"
  apps=$(grep 'Type=Application' /usr/share/applications/*.desktop | \
    cut -f 1 -d ':')
  while read app
  # Sort all this shit into categories
  do
    if [ ! -f ${cache}/$(basename ${app}) ] ; then
      cts=$(grep Categories= $app)
      if [ ! $(egrep "Development|TextEditor"<<<$cts) = "" ]
        then echo $(basename ${app}) >> ${cache}/dev
      elif [ ! "$(grep Graphics<<<$cts)" = "" ]
        then echo $(basename ${app}) >> ${cache}/gph
      elif [ ! "$(grep Office<<<$cts)" = "" ]
        then echo $(basename ${app}) >> ${cache}/ofc
      elif [ ! $(egrep "Multimedia|Audio|Video"<<<$cts) = "" ]
        then echo $(basename ${app}) >> ${cache}/mmd
      elif [ ! "$(grep Network<<<$cts)" = "" ]
        then echo $(basename ${app}) >> ${cache}/net
      elif [ ! "$(grep Settings<<<$cts)" = "" ]
        then echo $(basename ${app}) >> ${cache}/set
      elif [ ! "$(grep System<<<$cts)" = "" ]
        then echo $(basename ${app}) >> ${cache}/sys
      else
        true
      fi
      # Take only the info we want and make it sh sourceable
      egrep -m 3 "^Name=|^Icon=|^Exec=" $app \
        | sed -e 's%Name=%Name="%g' -e 's%Icon=%Icon="%g' -e \
        's%Exec=%Exec="%g' -e s/$/\"/ > ${cache}/$(basename ${app})
      # Source the resulting file
      . ${cache}/$(basename ${app})
      # Get the full path to the proper icon
      NewIcon=/usr/share/icons/hicolor/${ICON_SIZE}/apps/${Icon}.png
      [ -f $NewIcon ] || NewIcon=$(find /usr/share/icons/*/${ICON_SIZE} \
        /usr/share/pixmaps -name ${Icon}.png | head -n 1) >> \
        ${cache}/$(basename ${app})
      # Do some extra processing to remove %f|F|u|U and insert the full
      # icon path
      sed -i -e 's/%f//' -e 's/%F//' -e 's/%u//' -e 's/%U//' \
        -e s:Icon=\"${Icon}\":Icon=${NewIcon}: ${cache}/$(basename ${app})
    fi
  done<<<$apps
fi

# Actually build the menus
begin_${WM}_pipemenu

begin_${WM}_submenu "Development" "$CATEGORY_DEV_ICON" "DEVELOPMENT"
echo "  Icon = \"${CATEGORY_DEV_ICON}\""
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_dev}" ${cache}/dev)
end_${WM}_submenu

begin_${WM}_submenu "Graphics" "$CATEGORY_GPH_ICON" "GRAPHICS"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_gph}" ${cache}/gph)
end_${WM}_submenu

begin_${WM}_submenu "Office" "$CATEGORY_OFC_ICON" "OFFICE"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_ofc}" ${cache}/ofc)
end_${WM}_submenu

begin_${WM}_submenu "Multimedia" "$CATEGORY_MMD_ICON" "MULTIMEDIA"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_mmd}" ${cache}/mmd)
end_${WM}_submenu

begin_${WM}_submenu "Network" "$CATEGORY_NET_ICON" "NETWORK"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_net}" ${cache}/net)
end_${WM}_submenu

begin_${WM}_submenu "Settings" "$CATEGORY_SET_ICON" "SETTINGS"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_set}" ${cache}/set)
# Add an entry to rebuild the menu
create_${WM}_menuentry "Rebuild appmenu" \
  "${ICON_PATH}/actions/view-refresh.png" "rm -rf ${cache} && ${SELF}"
end_${WM}_submenu

begin_${WM}_submenu "System" "$CATEGORY_SYS_ICON" "SYSTEM"
while read app
do . ${cache}/${app}
  create_${WM}_menuentry "${Name}" "${Icon}" "${Exec}"
done<<<$(egrep -v "${exclude_sys}" ${cache}/sys)
end_${WM}_submenu

end_${WM}_pipemenu
