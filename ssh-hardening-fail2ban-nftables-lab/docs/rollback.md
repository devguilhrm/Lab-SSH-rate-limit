# Rollback seguro

Use estes comandos no servidor caso precise voltar ao estado anterior do lab.

```bash
sudo systemctl stop fail2ban
sudo fail2ban-client unban --all 2>/dev/null || true
sudo nft delete table inet ssh_guard 2>/dev/null || true
sudo ufw reload
sudo systemctl start fail2ban
sudo fail2ban-client status sshd
sudo ufw status verbose
```

Para desbanir apenas a Kali:

```bash
sudo fail2ban-client set sshd unbanip 192.168.1.225
```
