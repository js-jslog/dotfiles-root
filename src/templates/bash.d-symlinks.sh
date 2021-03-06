#! /bin/bash

function buildSymlinks() {
  local aliases=$@
  local alias
  local bashpath
  local bashname

  # adding the dotfiles-multiplexers own functions and vars
  for file in $(ls $multiplexer/src/dotfiles/bash.d/); do
    sudo ln -s $multiplexer/src/dotfiles/bash.d/$file $build/bash.d/dotfiles-multiplexer-$file
  done

  printf "\nBuilding bash.d symlinks from the following sources:\n"

  for alias in $aliases; do
    local dotsrepo=$(aliasesToRepoLocations $alias)
    # filling the bash.d folder with scripts to be run at shell initiation
    # bash files should contain exported environment variables and functions for interactive shells
    if [ -d $dotsrepo/bash.d/ ]; then
      for bashpath in $(find $dotsrepo/bash.d/ \( -name '*.sh' \))
      do
        bashname=$(basename "${bashpath}")
        sudo ln -s $bashpath $build/bash.d/$alias-$bashname

        printf "  $bashpath\n"

      done
    fi
  done
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

buildSymlinks $@
