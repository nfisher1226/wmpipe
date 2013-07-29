# First run, create our confir directory
[ ! -d "$HOME/.config/wmpipe" ] && install -d $HOME/.config/wmpipe
# Figure out where our global prefs are and read them in
if [ -f "$PREFIX/etc/wmpipe/conf" ] ; then
  CONFDIR="$PREFIX/etc/wmpipe"
else
  CONFDIR=/etc/wmpipe
fi
# First run, copy global config to user-config
[ ! -f "$HOME/.config/wmpipe/conf" ] && cp $CONFDIR/conf \
    $HOME/.config/wmpipe/conf
[ ! -f "$HOME/.config/wmpipe/icons.conf" ] && cp $CONFDIR/conf \
    $HOME/.config/wmpipe/icons.conf
# Source globals and then user prefs
. $CONFDIR/conf
. $CONFDIR/icons.conf
. $HOME/.config/wmpipe/conf
. $HOME/.config/wmpipe/icons.conf
