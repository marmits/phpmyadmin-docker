## 🐋 PhpMyAdmin

#### Bonus
Connexion distante via tunnel_ssh

### Build
`docker compose up -d`

### Connexion
http://localhost:9080/
```
Serveur : pma_marmits_mariadb
Utilisateur : root
Mot de passe : 123456
```

### Hôte
-- Créez un utilisateur dédié pour l'accès distant
```
CREATE USER 'docker_user'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'docker_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### `.env` (à créer / personnaliser / compléter)

```
# SSH
SSH_USER=
SSH_HOST=
SSH_PORT=

# MariaDB distante
REMOTE_HOST=127.0.0.1
REMOTE_PORT=3306

# Tunnel interne Docker
LOCAL_PORT=33007

# Chemins private key
SSH_KEY_PATH=

# IPV4
IPV4_DB=192.168.7.3
IPV4_SSH_TUNNEL=192.168.7.4
IPV4_PM=192.168.7.2
IPV4_SUBNET=192.168.7.0/24
IPV4_GATEWAY=192.168.7.1
```

### Acces Custom
Créer le fichier `config.user.inc.php`
avec : 
```
<?php
$i = 0;

/* Container mariadb */
$i++;
$cfg['Servers'][$i]['verbose'] = 'Container MySQL';
$cfg['Servers'][$i]['host'] = 'pma_marmits_mariadb'; 
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = false;

/* Configuration : IP LAN directe (Hôte) */
$i++;
$cfg['Servers'][$i]['verbose'] = 'Host MySQL (LAN IP)';
$cfg['Servers'][$i]['host'] = '192.168.1.99';  // Votre IP LAN 
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['user'] = 'docker_user';
$cfg['Servers'][$i]['password'] = '123456';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = false;

/* SSH TUNNEL */
$i++;
$cfg['Servers'][$i]['verbose'] = 'VPS via SSH (Docker)';
$cfg['Servers'][$i]['host'] = 'mariadb-ssh-tunnel'; // ou l'ip du container ssh-tunnel
$cfg['Servers'][$i]['port'] = getenv('LOCAL_PORT') ?: 33007;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['ssl'] = true;
$cfg['Servers'][$i]['ssl_verify'] = false;

```

### Firewall
- La règle INPUT pour accepter le trafic sur l'interface de l'hôte.  
`sudo ufw allow from 192.168.7.0/24 to any port 3306`

- Local port pour tunnel ssh (si par exemple `LOCAL_PORT=33007`).  
`sudo ufw allow from 192.168.7.0/24 to any port 33007`

### Sécurité renforcée
prévoir un durcissement SSH (AllowTcpForwarding + PermitOpen)