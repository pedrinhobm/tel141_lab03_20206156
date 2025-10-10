#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "[ERROR] Uso: $0 <VLAN_ID>"
    exit 1
fi

VLAN_ID=$1
INTERFAZ_INTERNET="ens3"
GW_IF="vlan$VLAN_ID"
THIRD_OCTET=$(($VLAN_ID / 10))
SUBNET="192.168.$THIRD_OCTET.0/24"

echo "Otorgando conectividad a Internet para la subred $SUBNET..."

# Regla de NAT/Masquerade para la salida
sudo iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$INTERFAZ_INTERNET" -j MASQUERADE

# Reglas para permitir el paso del tráfico (FORWARD)
sudo iptables -A FORWARD -i "$GW_IF" -o "$INTERFAZ_INTERNET" -j ACCEPT
sudo iptables -A FORWARD -i "$INTERFAZ_INTERNET" -o "$GW_IF" -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "Conectividad para VLAN $VLAN_ID habilitada."
