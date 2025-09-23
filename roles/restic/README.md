# Rôle Ansible Restic

Ce rôle Ansible installe et configure Restic pour effectuer des sauvegardes automatisées vers des backends de stockage cloud (S3, Backblaze B2, etc.).

## Fonctionnalités

- Installation automatique de Restic depuis GitHub selon l'architecture (AMD64, ARM64, 386)
- Support multi-OS (Debian/Ubuntu, RedHat/CentOS/Fedora)
- Sauvegarde automatisée via systemd timer
- Sauvegarde des bases de données (MySQL, PostgreSQL, MongoDB, etc.)
- Notifications par email en cas d'échec
- Politique de rétention configurable
- Chiffrement des dépôts avec mot de passe
- Sauvegarde séparée par serveur (nom d'hôte)

## Prérequis

- Ansible >= 2.9
- Accès root sur les serveurs cibles
- Backend de stockage configuré (S3, Backblaze B2, etc.)

## Variables principales

### Configuration de base
- `restic_version`: Version de Restic à installer (défaut: "0.18.1")
- `restic_repository_type`: Type de backend ("s3", "b2", "local")
- `restic_repository_url`: URL du dépôt de sauvegarde
- `restic_repository_password`: Mot de passe pour chiffrer le dépôt

### Credentials cloud
- `restic_aws_access_key_id` / `restic_aws_secret_access_key`: Pour S3
- `restic_b2_account_id` / `restic_b2_account_key`: Pour Backblaze B2

### Notifications
- `restic_notification_email`: Email pour les notifications d'échec

### Sauvegarde
- `restic_backup_paths`: Liste des répertoires à sauvegarder
- `restic_database_backups`: Configuration des dumps de bases de données
- `restic_exclude_patterns`: Patterns d'exclusion

### Planification
- Les sauvegardes s'exécutent entre 2h et 3h UTC avec un décalage automatique par serveur

## Utilisation

1. Copier le fichier d'exemple de configuration :
```bash
cp group_vars/provisionning-dev/restic.yml group_vars/your-environment/restic.yml
```

2. Modifier la configuration selon vos besoins :
```yaml
restic_repository_url: "s3:s3.amazonaws.com/your-bucket"
restic_repository_password: "{{ vault_restic_password }}"
restic_aws_access_key_id: "{{ vault_aws_access_key }}"
restic_aws_secret_access_key: "{{ vault_aws_secret_key }}"
```

3. Chiffrer les variables sensibles avec Ansible Vault :
```bash
ansible-vault encrypt_string 'your-password' --name 'vault_restic_password'
```

4. Ajouter le rôle à votre playbook :
```yaml
- hosts: servers
  roles:
    - restic
```

## Structure des fichiers

- `/usr/local/bin/restic`: Binaire Restic
- `/opt/restic/`: Scripts et configuration
- `/opt/restic/cache/`: Cache Restic
- `/opt/restic/dumps/`: Dumps temporaires des BDD
- `/var/log/restic-backup.log`: Logs de sauvegarde

## Exemples de configuration

### Sauvegarde MySQL complète
```yaml
restic_database_backups:
  - name: "mysql_all"
    command: "mysqldump --all-databases --single-transaction --routines --triggers"
    file: "mysql_all_databases.sql"
```

### Sauvegarde PostgreSQL
```yaml
restic_database_backups:
  - name: "postgresql_all"
    command: "sudo -u postgres pg_dumpall"
    file: "postgresql_all_databases.sql"
```

### Politique de rétention personnalisée
```yaml
restic_keep_within_daily: "30d"    # 30 jours de sauvegardes quotidiennes
restic_keep_within_weekly: "6m"    # 6 mois de sauvegardes hebdomadaires
restic_keep_within_monthly: "2y"   # 2 ans de sauvegardes mensuelles
```

## Commandes utiles

### Vérifier le statut du timer
```bash
systemctl status restic-backup.timer
```

### Exécuter une sauvegarde manuelle
```bash
sudo systemctl start restic-backup.service
```

### Consulter les logs
```bash
tail -f /var/log/restic-backup.log
```

### Lister les snapshots
```bash
sudo -u restic restic -r $REPOSITORY snapshots
```

## Sécurité

- Le service s'exécute avec un utilisateur dédié `restic`
- Les fichiers de configuration ont des permissions restrictives (600)
- Chaque serveur a son propre dépôt séparé
- Les mots de passe sont chiffrés avec le dépôt

## Dépannage

1. **Erreur d'initialisation du dépôt** : Vérifier les credentials et l'URL
2. **Échec de sauvegarde** : Consulter `/var/log/restic-backup.log`
3. **Timer non activé** : `systemctl enable restic-backup.timer`
