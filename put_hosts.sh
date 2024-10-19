#!/bin/bash

# Array associativo com os nodes
declare -A nodes

# Caminho do arquivo custom_hosts e o arquivo de inventário Ansible
CUSTOM_HOSTS_FILE="hosts"
INVENTORY_FILE="inventory"

# Verifica se o arquivo custom_hosts existe
if [ ! -f "$CUSTOM_HOSTS_FILE" ]; then
  echo "Arquivo $CUSTOM_HOSTS_FILE não encontrado!"
  exit 1
fi

# Verifica se a última linha é não vazia
if [[ -n $(tail -n1 "$CUSTOM_HOSTS_FILE") ]]; then
  # Adiciona uma nova linha ao arquivo
  echo >> "$CUSTOM_HOSTS_FILE"
fi

# Verifica se o arquivo de inventário existe, se não, cria
if [ ! -f "$INVENTORY_FILE" ]; then
  touch "$INVENTORY_FILE"
fi

# Ler o arquivo linha por linha
while IFS= read -r line; do
  # Ignorar linhas vazias
  if [[ -n "$line" ]]; then
    # Quebre a linha em duas partes e coloque-as nas variaveis ip e host, nessa ordem
    read -r ip host <<< $(echo "$line" | awk '{print $1, $2}')

    # Adicionar no array associativo, apenas se ambos não estiverem vazios
    if [[ -n "$ip" && -n "$host" ]]; then
      nodes["$host"]="$ip"
    fi
  fi
done < "$CUSTOM_HOSTS_FILE"

# Montar grupo do mestre
echo "[master]" > "$INVENTORY_FILE"
printf '%s ansible_host=%s ansible_user=root\n' "master" "${nodes[master]}" >> "$INVENTORY_FILE"

# Montar grupo dos slaves
echo -e "\n[slaves]" >> "$INVENTORY_FILE"
for host in "${!nodes[@]}"; do
  if [[ "$host" != "master" ]]; then
    printf '%s ansible_host=%s ansible_user=root\n' "$host" "${nodes[$host]}" >> "$INVENTORY_FILE"
  fi
done