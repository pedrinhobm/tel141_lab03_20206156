#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "[ERROR] Uso: $0 <NombreVM> <NombreOvS> <VLAN_ID> <PuertoVNC>"
    exit 1
fi

NOMBRE_VM=$1
NOMBRE_OVS=$2
VLAN_ID=$3
VNC_PORT=$4 

TAP_INTERFACE="tap-$NOMBRE_VM"
BASE_IMAGE="cirros-0.5.1-x86_64-disk.img"
VM_DISK="disk-$NOMBRE_VM.img" # creamos el disco y la mac con mi codigo PUCP 20206156
MAC=$(printf '20:20:61:56:%02x:%02x' $((RANDOM%256)) $((RANDOM%256)))

echo "La creación de VM: $NOMBRE_VM ha comenzado"

# Descargamos la imagen base por si no existe
if [ ! -f "$BASE_IMAGE" ]; then
    echo "Descargando imagen de disco CirrOS ..."
    wget -q -c http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img
fi

# Creamos una copia del disco
echo "Creando disco único para $NOMBRE_VM..."
cp "$BASE_IMAGE" "$VM_DISK"

# Configuramos la interfaz TAP y OVS
sudo ip tuntap add mode tap name "$TAP_INTERFACE"
sudo ip link set "$TAP_INTERFACE" up
sudo ovs-vsctl add-port "$NOMBRE_OVS" "$TAP_INTERFACE" tag="$VLAN_ID"

# Lanzamos la VM
echo "Lanzando QEMU..."
sudo qemu-system-x86_64 \
    -name "$NOMBRE_VM" \
    -enable-kvm \
    -m 256 \
    -vnc 0.0.0.0:$VNC_PORT \
    -netdev tap,id="$TAP_INTERFACE",ifname="$TAP_INTERFACE",script=no,downscript=no \
    -device e1000,netdev="$TAP_INTERFACE",mac="$MAC" \
    -daemonize \
    "$VM_DISK" # Usamos una copia del disco

echo "------------------------------------------"
echo "La VM '$NOMBRE_VM' con '$TAP_INTERFACE' ha sido creada :D"
echo " 1) MAC Address: $MAC"
echo " 2) VNC en host: puerto $(($VNC_PORT + 5900))"
echo "------------------------------------------"
