
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVESIZE=1000
export LISTMAX=0
export EDITOR="$(which vim)"

if [ -d "${HOME}/bin" ] ; then
    export PATH=${HOME}/bin:${PATH}
fi


# for cygwin
OS=$(uname -o)
if [ "$OS" = "Cygwin" ]; then
    export LESS=MrXEd
    export TERM=cygwin
    export CFLAGS="-I/usr/local/include -I/usr/include"

    export LANG=ja_JP.SJIS
fi


# local::lib
export PATH="$HOME/local/bin:$PATH"
export PERL5LIB="$HOME/local/lib/perl5:$HOME/local/lib/perl5/site_perl:$PERL5LIB"
export GISTY_DIR="$HOME/work/gist"

export PKG_DBDIR="$HOME/local/var/db/pkg"
export PORT_DBDIR="$HOME/local/var/db/pkg"
export INSTALL_AS_USER
export LD_LIBRARY_PATH="$HOME/local/lib"
mkdir -p ~/local/var/db/pkg
