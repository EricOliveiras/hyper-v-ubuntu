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

# Instala o Samba
echo "Instalando o Samba..."
sudo apt-get install samba -y

# Configura o Samba para compartilhar a pasta /var/www/html
echo "Configurando o Samba para compartilhar a pasta /var/www/html..."
sudo tee -a /etc/samba/smb.conf <<EOL

[www]
   path = /var/www/html
   browseable = yes
   writable = yes
   guest ok = yes
   create mask = 0777
   directory mask = 0777
EOL

# Ajusta permissões para o Samba
echo "Ajustando permissões para o Samba..."
sudo chown -R nobody:nogroup /var/www/html

# Reinicia o serviço do Samba
echo "Reiniciando o Samba..."
sudo systemctl restart smbd
sudo systemctl enable smbd

# Clona o repositório para um diretório temporário
echo "Clonando o repositório do projeto para um diretório temporário..."
sudo git clone https://github.com/EricOliveiras/myportfolio.git /tmp/myportfolio

# Remove arquivos existentes do diretório /var/www/html
echo "Removendo arquivos antigos de /var/www/html..."
sudo rm -rf /var/www/html/*

# Move o conteúdo do diretório temporário para /var/www/html
echo "Movendo o conteúdo para /var/www/html..."
sudo mv /tmp/myportfolio/* /var/www/html/

# Remove o diretório temporário
sudo rm -rf /tmp/myportfolio

# Ajusta permissões para o novo conteúdo
echo "Ajustando permissões para o novo conteúdo..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Instala o phpMyAdmin
echo "Instalando o phpMyAdmin..."
sudo apt-get install phpmyadmin -y

# Verifica se a instalação foi bem-sucedida
if ! dpkg -l | grep -q phpmyadmin; then
    echo "phpMyAdmin não foi instalado corretamente."
    exit 1
fi

# Configura o phpMyAdmin
echo "Configurando o phpMyAdmin..."
# Adiciona a configuração do phpMyAdmin ao Apache
if ! grep -q "phpmyadmin/apache.conf" /etc/apache2/apache2.conf; then
    echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf
fi
# Reinicia o Apache para aplicar as configurações do phpMyAdmin
echo "Reiniciando o Apache para aplicar as configurações do phpMyAdmin..."
sudo systemctl restart apache2

echo "Configuração do servidor concluída!"
