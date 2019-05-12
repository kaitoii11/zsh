ZDOTDIR=$HOME/.zsh
export LANG=ja_JP.UTF-8
#export PYTHONPATH="/opt/local/bin/python:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/site-packages:/usr/local/lib/python2.7/site-packages:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages"
if [ -e /opt/local/bin/python  ]; then
  export PYTHONPATH="/opt/local/bin/python"
else
  export PYTHONPATH="/usr/bin/python"
fi
export PATH="/opt/local/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/bin:/opt/local/sbin:/opt/local/lib:/usr/local/lib:/opt/local/include:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)
export MANPATH="/opt/local/share/man:/usr/local/man:/opt/local/man:$MANPATH"
export DYLD_FALLBACK_LIBRARY_PATH="$HOME/lib:/usr/local/lib:/lib:/usr/lib:/opt/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
typeset -U path PATH
export LC_ALL="ja_JP.UTF-8"
if [ -e /opt/local/bin/vim  ]; then
  export EDITOR=/opt/local/bin/vim
else
  export EDITOR=/usr/bin/vim
fi
zmodload zsh/zprof
