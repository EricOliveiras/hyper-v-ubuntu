# Comandos Vagrant para Gerenciamento de Máquina Virtual

Este documento fornece uma lista dos comandos Vagrant usados para gerenciar sua máquina virtual.

## Comandos

### Criar e Inicializar a Máquina Virtual


```bash
Para criar e iniciar a máquina virtual:
vagrant up --provider=hyperv

Para recarregar a máquina virtual e aplicar as configurações de provisionamento novamente:
vagrant reload --provision

Destruir a máquina virtual:
vagrant destroy -f

Para acessar a VM:
vagrant ssh

Para acessar a máquina virtual via SSH:
ssh -p 22 vagrant@port

Para acessar a máquina virtual via HTTP:
ssh -p 80 http://port:80