#!/bin/bash

# Configura DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

# Verifica a conectividade antes de começar
echo "Verificando conectividade com a Internet..."
ping -c 4 google.com || { echo "Não foi possível conectar à Internet. Verifique as configurações de rede."; exit 1; }

# Atualiza a lista de pacotes e atualiza o sistema
echo "Atualizando o sistema..."
sudo apt-get update --fix-missing
sudo apt-get upgrade -y

# Instala o Apache2
echo "Instalando o Apache2..."
sudo apt-get install apache2 -y

# Verifica se o Apache foi instalado corretamente
if ! command -v apache2 > /dev/null; then
    echo "Apache2 não foi instalado corretamente."
    exit 1
fi

# Inicia e habilita o Apache2 para iniciar no boot
echo "Iniciando e habilitando o Apache2..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Instala o MySQL Server
echo "Instalando o MySQL Server..."
sudo apt-get install mysql-server -y

# Verifica se o MySQL foi instalado corretamente
if ! command -v mysql > /dev/null; then
    echo "MySQL Server não foi instalado corretamente."
    exit 1
fi

# Inicia e habilita o MySQL para iniciar no boot
echo "Iniciando e habilitando o MySQL Server..."
sudo systemctl start mysql
sudo systemctl enable mysql

# Instala o PHP e módulos necessários
echo "Instalando o PHP e módulos necessários..."
sudo apt-get install php libapache2-mod-php php-mysql -y

# Verifica se o PHP foi instalado corretamente
if ! command -v php > /dev/null; then
    echo "PHP não foi instalado corretamente."
    exit 1
fi

# Reinicia o Apache para aplicar as mudanças
echo "Reiniciando o Apache2..."
sudo systemctl restart apache2 || { echo "Falha ao reiniciar o Apache2."; exit 1; }

# Concede permissões totais à pasta /var/www/html
echo "Concedendo permissões à pasta /var/www/html..."
sudo chmod -R 777 /var/www/html

# Cria novo usuário com senha temporária
echo "Criando novo usuário..."
NEW_USER="newuser"
TEMP_PASS="newpassword" # Senha temporária
sudo adduser --quiet --disabled-password --gecos "" $NEW_USER
echo "$NEW_USER:$TEMP_PASS" | sudo chpasswd

# Força a alteração da senha no próximo login
echo "Forçando a alteração de senha no próximo login..."
sudo chage -d 0 $NEW_USER

# Verifica as versões instaladas de Apache, MySQL e PHP
echo "Versões instaladas:"
apache2 -v
mysql --version
php -v

echo "Configuração do servidor concluída!"
