#!/bin/bash
# Remove arquivo de lock antigo se o container morreu feio antes
sudo rm -f /var/run/neo4j/neo4j.pid

echo "[*] Iniciando Neo4j..."
# Inicia e espera 15 segundos para garantir que subiu
sudo neo4j start


echo "[*] Neo4j deve estar UP. Iniciando Shell..."
exec "$@"
