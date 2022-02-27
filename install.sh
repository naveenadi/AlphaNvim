#! /bin/sh

getPlatform() {
  case "$(uname -s)" in
  Linux*) platform=Linux ;;
  Darwin*) platform=Mac ;;
  *) platform="UNKNOWN:${unameOut}" ;;
  esac
  echo $platform
}

warnNvim() {
  echo "Please install neovim"
}

warnGit() {
  echo "Please install git"
}

changeDirname() {
  mv $HOME/.config/nvim $HOME/.config/nvim.bak
  echo "Your existing nvim config has been changed to oldneovim"
  cloneRepo
}

installPacker() {
	if [ -d ~/.local/share/nvim/site/pack/packer ]; then
	  echo "Clearning previous packer installs"
	  rm -rf ~/.local/share/nvim/site/pack
	fi
	
	echo "\n=> Installing packer"
	git clone https://github.com/wbthomason/packer.nvim \
	  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	echo "=> packer installed!"
}

cloneRepo() {
  echo "Cloning repo..."
  git clone https://github.com/aditya612/AlphaVim ~/.config/nvim --depth 1
  nvim +'hi NormalFloat guibg=#1e222a' +PackerSync
}

changeShell () {
	# change shell in nvim config
	read -p "which shell do you use?: " shellname
	echo "$shellname"
	
	if [ "$(get_platform)" = "Mac" ]; then
	  gsed -i "s/bash/$shellname/g" ~/.config/nvim/lua/mappings.lua
	else
	  sed -i "s/bash/$shellname/g" ~/.config/nvim/lua/mappings.lua
	fi
	
	echo "\n=> shell changed to $shellname on nvim successfully!"
	echo "\n=> neovim will open with some errors , just press enter" && sleep 1
}

which nvim >/dev/null && echo "Neovim is installed" || warnNvim
which git >/dev/null && echo "Git is installed" || warnGit

[ -d "$HOME/.config/nvim" ] && changeDirname || cloneRepo
