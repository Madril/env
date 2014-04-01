PLATFORM='unknown'
unamestr=`uname`

if [[ "$unamestr" == 'Linux' ]]; then
   PLATFORM='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   PLATFORM='darwin'
fi

#python manage.py anywhere

_pmanage_backsearch(){
  if [ ! -f manage.py ]; then
    if [[ `pwd` == "/" ]]; then
      echo "Not within a Django Project"
    else
      cd ..
      _pmanage_backsearch
    fi
  else
    if [[ $dir != `pwd` ]]; then
      echo "$fg[green]Using `pwd`$reset_color"
    fi
    python manage.py $args
  fi
}

function _pmanage(){
  local dir=`pwd`
  local args=$@
  _pmanage_backsearch
  cd $dir
}

alias p=_pmanage

#mvn anywhere

_mvn_backsearch(){
  if [ ! -f pom.xml ]; then
    if [[ `pwd` == "/" ]]; then
      echo "Not within a Maven Project"
    else
      cd ..
      _mvn_backsearch
    fi
  else
    if [[ $dir != `pwd` ]]; then
      echo "$fg[green]Using `pwd`$reset_color"
    fi
    mvn $args
  fi
}

function _mvn(){
  local dir=`pwd`
  local args=$@
  _mvn_backsearch
  cd $dir
}


#update dotenv

upenv(){
  pushd "$HOME/.env" > /dev/null
  git pull origin
  if [[ $SHELL == *bash* ]]; then
    source "$HOME/.bashrc"
  else
    source "$HOME/.zshrc"
  fi
  popd > /dev/null
}

alias vlc='open -a VLC'

source "$HOME/.env/vars.sh"

