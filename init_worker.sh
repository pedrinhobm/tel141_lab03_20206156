#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "[ERROR] Uso: $0 <nombreOvS> <InterfazAConectar>"
    exit 1
fi

NOMBRE_OVS=$1
INTERFAZ=$2

echo "La configuración del worker ha iniciado"
if ! sudo ovs-vsctl br-exists "$NOMBRE_OVS"; then
    sudo ovs-vsctl add-br "$NOMBRE_OVS"
fi

# Levantamos las interfaces
sudo ip link set "$NOMBRE_OVS" up
sudo ip link set "$INTERFAZ" up

# Conectamos la interfaz física al bridge
sudo ovs-vsctl add-port "$NOMBRE_OVS" "$INTERFAZ"
echo "La configuración del worker ha culminado"
