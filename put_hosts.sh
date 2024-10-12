#!/bin/bash

# Caminho do arquivo custom_hosts e o arquivo de inventário Ansible
CUSTOM_HOSTS_FILE="custom_hosts"
INVENTORY_FILE="inventory"

# Verifica se o arquivo custom_hosts existe
if [ ! -f "$CUSTOM_HOSTS_FILE" ]; then
  echo "Arquivo $CUSTOM_HOSTS_FILE não encontrado!"
  exit 1
fi

# Verifica se o arquivo de inventário existe, se não, cria
if [ ! -f "$INVENTORY_FILE" ]; then
  echo "[node_hosts]" > "$INVENTORY_FILE"
fi

# Lê o arquivo custom_hosts linha por linha
while IFS= read -r line; do
  # Divide a linha em IP e nome de host (apelido)
  IP=$(echo "$line" | awk '{print $1}')
  HOST=$(echo "$line" | awk '{print $2}')

  # Verifica se o host já está presente no arquivo de inventário
  if grep -q "$HOST ansible_host=$IP" "$INVENTORY_FILE"; then
    echo "Host $HOST com IP $IP já está presente no inventário."
  else
    # Adiciona o host ao inventário com o formato ansible_host
    echo "$HOST ansible_host=$IP ansible_user=root" >> "$INVENTORY_FILE"
    echo "Adicionando $HOST com IP $IP ao inventário."
  fi
done < "$CUSTOM_HOSTS_FILE"
