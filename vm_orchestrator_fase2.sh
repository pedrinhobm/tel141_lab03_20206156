#!/bin/bash
echo "Iniciamos la fase 2 del orquestador"

# Inicializamos el headnode como router y firewall
sudo bash init_headnode.sh br-int ens4

# Creamos las redes para cada VLAN
sudo bash net_create.sh ns-vlan100 br-int 100 192.168.10.50,192.168.10.100 192.168.10.1/24
sudo bash net_create.sh ns-vlan200 br-int 200 192.168.20.50,192.168.20.100 192.168.20.1/24
sudo bash net_create.sh ns-vlan300 br-int 300 192.168.30.50,192.168.30.100 192.168.30.1/24

# Otorgamos conectividad a Internet por VLAN
sudo bash internet_conectivity.sh 100
sudo bash internet_conectivity.sh 200
sudo bash internet_conectivity.sh 300

echo "La fase 2 del orquestador ha culminado"
