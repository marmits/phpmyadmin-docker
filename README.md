## 🐋 PhpMyAdmin
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


### Acces Custom
Créer le fichier `config.user.inc.php`
avec : 
```
<?php
$i = 0;


$i++;
$cfg['Servers'][$i]['verbose'] = 'Container MySQL';
$cfg['Servers'][$i]['host'] = 'pma_marmits_mariadb'; 
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = false;


/* Configuration 1 : IP LAN directe */
$i++;
$cfg['Servers'][$i]['verbose'] = 'Host MySQL (LAN IP)';
$cfg['Servers'][$i]['host'] = '192.168.1.99';  // Votre IP LAN 
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['user'] = 'docker_user';
$cfg['Servers'][$i]['password'] = '123456';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = false;
```


### Firewall
La règle INPUT pour accepter le trafic sur l'interface de l'hôte.  
`sudo ufw allow from 192.168.7.0/24 to any port 3306`