# Rôle Ansible Fail2ban

Ce rôle Ansible installe et configure Fail2ban pour protéger automatiquement vos serveurs contre les attaques par force brute et les tentatives d'intrusion.

## Fonctionnalités

- **Installation automatique** sur Debian/Ubuntu et RedHat/CentOS/Fedora
- **Détection automatique des services** installés (SSH, Nginx, Apache, FTP, SFTP)
- **Protection SSH** : Blocage des tentatives de connexion échouées
- **Protection web** : Anti-flood HTTP pour Nginx et Apache
- **Protection FTP/SFTP** : Surveillance des connexions FTP et transferts SFTP
- **Liste blanche d'IPs** : Protection des IPs autorisées
- **Notifications email** : Rapports d'activité par email
- **Bantime configurable** : 7 jours par défaut
- **Configuration flexible** : Jails personnalisables par environnement

## Prérequis

- Ansible >= 2.9
- Accès root sur les serveurs cibles
- Iptables installé (installé automatiquement)
