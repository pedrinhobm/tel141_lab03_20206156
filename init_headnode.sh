#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "[ERROR] Uso: $0 <nombreOvS> <InterfacesAConectar>"
    exit 1
fi

NOMBRE_OVS=$1
INTERFAZ_DATOS=$2

echo "La inicializacion del HeadNode como Gateway/Firewall ha comenzado"

# Creamos un OvS local por si no existe
sudo ovs-vsctl add-br "$NOMBRE_OVS"
sudo ip link set "$NOMBRE_OVS" up

# Conectamos la interfaz de datos al OvS
sudo ovs-vsctl add-port "$NOMBRE_OVS" "$INTERFAZ_DATOS"

# Activamos IPv4 Forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Cambiamos la política por defecto de FORWARD a DROP
echo "Cambiando la politica por defecto"
sudo iptables -P FORWARD DROP

echo "La inicializacion del HeadNode ha culminado"
