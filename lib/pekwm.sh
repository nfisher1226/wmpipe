#  pekwm.sh - shell functions for creating pekwm menus
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

#  name: begin_pekwm_pipemenu
#  @param none
#  @return 'Dynamic {'
#
begin_pekwm_pipemenu () {
	echo 'Dynamic {'
}

#  name: end_pekwm_pipemenu
#  @param none
#  @return '}'
#
end_pekwm_pipemenu () {
	echo '}'
}


#  name: begin_pekwm_submenu
#  @param TITLE (string) ICON (string)
#  @return submenu opening
#  begins an pekwm submenu

begin_pekwm_submenu () {
	TITLE="$1"
	ICON="$2"
	echo "Submenu = \"$TITLE\" { Icon = \"$ICON\""
}

#  name: end_pekwm_submenu
#  @param
#  @return '}'
#  closes an pekwm submenu

end_pekwm_submenu () {
	echo '}'
}

#  name: open_pekwm_pipemenu
#  @param TITLE (string) ICON (string) RELOAD (int) COMMAND (string)
#  @return
#  opens an pekwm pipemenu

open_pekwm_pipemenu () {
	TITLE="$1"
	COMMAND="$2"
	ICON="$3"
	cat << EOF
Submenu = "$TITLE"
  { Icon = "$ICON"
    Entry { Actions = "Dynamic $COMMAND" }
  }
EOF
}

#  name: create_pekwm_menuentry
#  @param TITLE (string) ICON (string) COMMAND (string)
#  @return
#  creates an pekwm menu program entry

create_pekwm_menuentry () {
	TITLE="$1"
	ICON="$2"
	COMMAND="$3"
	cat << EOF
  Entry = "$TITLE"
    { Icon = "$ICON"; Actions = "Exec $COMMAND &" }
EOF
}

#
#  name: print_separator
#  @param
#  @return "separator {}"
#
print_separator () {
	echo 'Separator {}'
}
