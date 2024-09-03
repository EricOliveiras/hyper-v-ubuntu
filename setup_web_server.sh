#!/bin/bash

# Atualiza a lista de pacotes e atualiza o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instala o Apache2
echo "Instalando o Apache2..."
sudo apt install apache2 -y

# Inicia e habilita o Apache2 para iniciar no boot
echo "Iniciando e habilitando o Apache2..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Instala o MySQL Server
echo "Instalando o MySQL Server..."
sudo apt install mysql-server -y

# Inicia e habilita o MySQL para iniciar no boot
echo "Iniciando e habilitando o MySQL Server..."
sudo systemctl start mysql
sudo systemctl enable mysql

# Instala o PHP e módulos necessários
echo "Instalando o PHP e módulos necessários..."
sudo apt install php libapache2-mod-php php-mysql -y

# Reinicia o Apache para aplicar as mudanças
echo "Reiniciando o Apache2..."
sudo systemctl restart apache2

# Verifica as versões instaladas de Apache, MySQL e PHP
echo "Versões instaladas:"
apache2 -v
mysql --version
php -v

echo "Configuração do servidor concluído!"
