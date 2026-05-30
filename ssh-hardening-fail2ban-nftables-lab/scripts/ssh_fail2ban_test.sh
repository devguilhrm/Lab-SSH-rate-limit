#!/usr/bin/env bash

# Lab controlado para testar Fail2Ban contra SSH.
# Use apenas em ambiente próprio/autorizado.

TARGET_IP="192.168.1.222"
TARGET_USER="usuario_inexistente"
FAKE_PASSWORD="senha_errada"
ATTEMPTS=7
SLEEP_TIME=1

echo "[*] Iniciando teste controlado contra $TARGET_IP"
echo "[*] Usuário usado no teste: $TARGET_USER"
echo "[*] Tentativas: $ATTEMPTS"
echo "[*] Intervalo: ${SLEEP_TIME}s"
echo "[*] IP local da Kali:"
hostname -I
echo

for i in $(seq 1 "$ATTEMPTS"); do
    echo "[*] Tentativa $i/$ATTEMPTS"

    sshpass -p "$FAKE_PASSWORD" ssh \
      -o PreferredAuthentications=password \
      -o PubkeyAuthentication=no \
      -o PasswordAuthentication=yes \
      -o ConnectTimeout=3 \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      "$TARGET_USER@$TARGET_IP" "exit"

    echo
    sleep "$SLEEP_TIME"
done

echo "[*] Teste finalizado."
echo "[*] Agora verifique no servidor:"
echo "    sudo fail2ban-client status sshd"
echo "    sudo journalctl -u ssh --since '10 minutes ago'"
echo "    sudo tail -n 40 /var/log/fail2ban.log"
