#!/usr/bin/env bash

# Actualizar los paquetes del sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
sudo apt install -y curl
sudo apt install xclip xsel wl-clipboard

# Descargar la última versión de Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
    echo "❌ Error: No se pudo descargar Neovim. Revisa la URL o la conexión a internet."
    exit 1
fi

# Extraer el contenido del tarball
tar xzvf nvim-linux-x86_64.tar.gz

# Mover los archivos a /opt/nvim
sudo mv nvim-linux-x86_64 /opt/nvim

# Eliminar el archivo tarball descargado
rm nvim-linux-x86_64.tar.gz

# Agregar Neovim al PATH si no está ya agregado
if ! grep -q '/opt/nvim/bin' ~/.bashrc; then
    echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.bashrc
fi

# Recargar la configuración de bash para la sesión actual
source ~/.bashrc

# Mostrar la versión de Neovim para confirmar la instalación
nvim --version

