#!/bin/bash

# Atualiza o apt e instala dependências
sudo apt-get update
sudo apt-get install -y git unzip xz-utils curl

# Baixa e configura o Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PWD/flutter/bin:$PATH"

# Verifica instalação
flutter --version

# Instala dependências do Flutter
flutter doctor

# Faz o build web
flutter build web