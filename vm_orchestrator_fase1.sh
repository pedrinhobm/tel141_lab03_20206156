#!/bin/bash

echo "Iniciamos la fase 1 del orquestador"

# Ejecución del OFS
echo "Procesando el OFS"
ssh ubuntu@10.0.10.5 'sudo bash -s' < init_ofs.sh br-data ens6 ens7 ens8 
# para mi VNRT, indicado tambien en acotaciones adicionales.txt

# Ejecución del worker 1 (server2)
echo "Procesando el primer worker"
ssh ubuntu@10.0.10.2 'sudo bash -s' < init_worker.sh br-int ens4
ssh ubuntu@10.0.10.2 'sudo bash -s' < vm_create.sh VM1-W1 br-int 100 1
ssh ubuntu@10.0.10.2 'sudo bash -s' < vm_create.sh VM2-W1 br-int 200 2
ssh ubuntu@10.0.10.2 'sudo bash -s' < vm_create.sh VM3-W1 br-int 300 3

# Ejecución del worker 2 (server3)
echo "Procesando el segundo worker"
ssh ubuntu@10.0.10.3 'sudo bash -s' < init_worker.sh br-int ens4
ssh ubuntu@10.0.10.3 'sudo bash -s' < vm_create.sh VM1-W2 br-int 100 4
ssh ubuntu@10.0.10.3 'sudo bash -s' < vm_create.sh VM2-W2 br-int 200 5
ssh ubuntu@10.0.10.3 'sudo bash -s' < vm_create.sh VM3-W2 br-int 300 6

# Ejecución del worker 3 (server4)
echo "Procesando el tercer worker"
ssh ubuntu@10.0.10.4 'sudo bash -s' < init_worker.sh br-int ens4
ssh ubuntu@10.0.10.4 'sudo bash -s' < vm_create.sh VM1-W3 br-int 100 7
ssh ubuntu@10.0.10.4 'sudo bash -s' < vm_create.sh VM2-W3 br-int 200 8
ssh ubuntu@10.0.10.4 'sudo bash -s' < vm_create.sh VM3-W3 br-int 300 9

echo "La fase 1 del orquestador ha culminado"
