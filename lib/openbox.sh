#  openbox.sh - shell functions for creating openbox menus
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

#  name: begin_openbox_pipemenu
#  @param none
#  @return '<openbox_pipe_menu>'
#
begin_openbox_pipemenu () {
	echo '<openbox_pipe_menu>'
}
#  name: end_openbox_pipemenu
#  @param none
#  @return '</openbox_pipe_menu>'
#
end_openbox_pipemenu () {
	echo '</openbox_pipe_menu>'
}


#  name: begin_openbox_submenu
#  @param TITLE (string) ICON (string)
#  @return submenu opening
#  begins an openbox submenu

begin_openbox_submenu () {
	TITLE="$1"
	ICON="$2"
	ID="$3"
	echo "  <menu id=\"$ID\" label=\"$TITLE\" icon=\"$ICON\">"
}

#  name: end_openbox_submenu
#  @param
#  @return '</menu>'
#  closes an openbox submenu

end_openbox_submenu () {
	echo '  </menu>'
}

#  name: open_openbox_pipemenu
#  @param TITLE (string) ICON (string) RELOAD (int) COMMAND (string)
#  @return
#  opens an openbox pipemenu

open_openbox_pipemenu () {
	TITLE="$1"
	COMMAND="$2"
	ICON="$3"
	echo "  <menu id=\"pipemenu: $TITLE\" label=\"TITLE\" execute=\"$COMMAND\"/>"
}

#  name: create_openbox_menuentry
#  @param TITLE (string) ICON (string) COMMAND (string)
#  @return
#  creates an openbox menu program entry

create_openbox_menuentry () {
	TITLE="$1"
	ICON="$2"
	COMMAND="$3"
	cat << EOF
    <item label="$TITLE" icon="$ICON">
      <action name="Execute">
        <command>$COMMAND</command>
      </action>
    </item>
EOF
}

#
#  name: print_separator
#  @param label
#  @return '<separator />'
#
print_separator () {
	if [ "$1" = "" ] ; then
	  echo '  <separator />'
	else
	  echo "  <separator label=\"$@\" />"
	fi
}
