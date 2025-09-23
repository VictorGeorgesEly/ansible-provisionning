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
