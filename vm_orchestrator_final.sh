#!/bin/bash
echo "Iniciandoos el orquestador final"
echo "Fase 1: Creacion de VMs e infraestructura base"
sudo bash vm_orchestrator_fase1.sh
echo "Fase 1 culminada, esperemos 10 segundos para estabilizar la red"
sleep 10
echo "Fase 2: Configuracion de routing y DHCP"
sudo bash vm_orchestrator_fase2.sh
echo "La topologia ha sido desplegada por completo"
