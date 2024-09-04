#!/usr/bin/bash

# update packages
sudo apt update && sudo apt upgrade -y

# install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
if [ -f nvim-linux64.tar.gz ]; then
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
	rm nvim-linux64.tar.gz

	# install required packages
	sudo apt install -y npm unzip

else
	echo "Error: no se puso descargar Neovim"
fi

# recargar la terminal
source ~/.bashrc

