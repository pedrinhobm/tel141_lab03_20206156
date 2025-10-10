#!/bin/bash
if [ "$#" -ne 5 ]; then
    echo "[ERROR] Uso: $0 <NombreNS> <NombreOvS> <VLAN_ID> <RangoDHCP> <DefaultGateway>"
    exit 1
fi

NOMBRE_NS=$1
NOMBRE_OVS=$2
VLAN_ID=$3
RANGO_DHCP=$4
DEFAULT_GATEWAY=$5

IP_GATEWAY=$(echo "$DEFAULT_GATEWAY" | cut -d'/' -f1)
IP_SERVICIO_DHCP=$(echo "$IP_GATEWAY" | cut -d'.' -f1-3).2/24 # La IP del servicio el siguiente del gateway
NETMASK="255.255.255.0"
VETH_OUT="veth-ns-$VLAN_ID"; VETH_IN="veth-gw-$VLAN_ID"
GW_IF="vlan$VLAN_ID"

echo "Creando red para VLAN $VLAN_ID"

# Creamos el gateway
echo "Creando interfaz de Gateway '$GW_IF'"
sudo ovs-vsctl add-port "$NOMBRE_OVS" "$GW_IF" tag="$VLAN_ID" \
    -- set interface "$GW_IF" type=internal
sudo ip addr add "$DEFAULT_GATEWAY" dev "$GW_IF"
sudo ip link set "$GW_IF" up

# Creamos del namespace y DHCP
echo "Creando namespace '$NOMBRE_NS' para el servicio DHCP"
sudo ip netns add "$NOMBRE_NS"
sudo ip link add "$VETH_OUT" type veth peer name "$VETH_IN"
sudo ip link set "$VETH_IN" netns "$NOMBRE_NS"
sudo ip netns exec "$NOMBRE_NS" ip addr add "$IP_SERVICIO_DHCP" dev "$VETH_IN"
sudo ip netns exec "$NOMBRE_NS" ip link set dev "$VETH_IN" up
sudo ip netns exec "$NOMBRE_NS" ip link set dev lo up
sudo ip link set dev "$VETH_OUT" up
sudo ovs-vsctl add-port "$NOMBRE_OVS" "$VETH_OUT" tag="$VLAN_ID"

# Iniciamos el servidor DHCP
echo "Iniciando servidor DHCP"
sudo ip netns exec "$NOMBRE_NS" dnsmasq \
    --interface="$VETH_IN" \
    --dhcp-range="$RANGO_DHCP,$NETMASK" \
    --dhcp-option=3,"$IP_GATEWAY" \
    --dhcp-option=6,8.8.8.8,8.8.4.4

echo "La red para VLAN $VLAN_ID logró ser creada :D"
