#  icewm.sh - shell functions for creating icewm menus
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

#  name: begin_icewm_pipemenu
#  @param none
#  @return true
#  empty function for compatibility
begin_icewm_pipemenu () {
	true
}

#  name: end_icewm_pipemenu
#  @param none
#  @return true
#  empty function for compatibility
end_icewm_pipemenu () {
	true
}


#  name: begin_icewm_submenu
#  @param TITLE (string) ICON (string)
#  @return submenu opening
#  begins an icewm submenu

begin_icewm_submenu () {
	TITLE="$1"
	ICON=$2
	echo "menu \"$TITLE\" $ICON {"
}

#  name: end_icewm_submenu
#  @param
#  @return '}'
#  closes an icewm submenu

end_icewm_submenu () {
	echo '}'
}

#  name: open_icewm_pipemenu
#  @param TITLE (string) ICON (string) RELOAD (int) COMMAND (string)
#  @return
#  opens an icewm pipemenu

open_icewm_pipemenu () {
	TITLE="$1"
	COMMAND=$2
	ICON=$3
	RELOAD=$4
	echo "menuprogreload \"$TITLE\" \"$ICON\" $RELOAD $COMMAND"
}

#  name: create_icewm_menuentry
#  @param TITLE (string) ICON (string) COMMAND (string)
#  @return
#  creates an icewm menu program entry

create_icewm_menuentry () {
	TITLE="$1"
	ICON=$2
	COMMAND="$3"
	echo "prog \"$TITLE\" $ICON $COMMAND"
}

#
#  name: print_separator
#  @param
#  @return "separator {}"
#
print_separator () {
	echo 'separator'
}
