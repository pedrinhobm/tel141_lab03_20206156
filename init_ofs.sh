#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "[ERROR] Uso: $0 <NombreOvS> <puerto1> <puerto2> ..."
    exit 1
fi
NOMBRE_OVS=$1
shift
INTERFACES=("$@")


echo "La configuración OFS ha comenzado"
if ! sudo ovs-vsctl br-exists "$NOMBRE_OVS"; then
    sudo ovs-vsctl add-br "$NOMBRE_OVS"
fi

# Levantamos el OVS
sudo ip link set "$NOMBRE_OVS" up

# Coenctamos las interfaces
for IFACE in "${INTERFACES[@]}"; do
    sudo ip addr flush dev "$IFACE"
    sudo ip link set "$IFACE" up
    sudo ovs-vsctl add-port "$NOMBRE_OVS" "$IFACE"
done

echo "La configuración OFS ha culminado"
