# Ansible Role: Firewall (UFW)

Ce rôle Ansible configure le firewall UFW (Uncomplicated Firewall) sur les systèmes Debian/Ubuntu.

## Fonctionnalités

- Installation et configuration d'UFW
- Configuration des politiques par défaut
- Gestion des règles d'autorisation pour les ports entrants
- Blocage d'adresses IP spécifiques (avec suppression automatique)
- **Protection anti-DDoS avancée (SYN flood, ICMP flood, UDP flood, scan de ports)**
- Support de Docker avec règles spécialisées
- Configuration optimisée pour éviter les ralentissements lors de multiples exécutions

## Variables

### Variables principales

- `ufw_enabled`: Active/désactive UFW (défaut: `true`)
- `ufw_default_incoming_policy`: Politique par défaut pour le trafic entrant (défaut: `"deny"`)
- `ufw_default_outgoing_policy`: Politique par défaut pour le trafic sortant (défaut: `"allow"`)
- `ufw_logging`: Niveau de logging (défaut: `"low"`)

### Protection anti-DDoS

```yaml
ufw_ddos_enabled: true                    # Active la protection anti-DDoS

# Configuration des limites anti-DDoS
ufw_ddos_syn_limit: "25/minute"          # Limite des connexions SYN par minute
ufw_ddos_syn_burst: "20"                 # Burst autorisé pour les connexions SYN
ufw_ddos_icmp_limit: "1/second"          # Limite des pings ICMP par seconde
ufw_ddos_icmp_burst: "2"                 # Burst autorisé pour les pings ICMP
ufw_ddos_udp_limit: "50/minute"          # Limite des paquets UDP par minute
ufw_ddos_udp_burst: "20"                 # Burst autorisé pour les paquets UDP
ufw_ddos_conn_limit: "20"                # Connexions simultanées max par IP
```

**Protections incluses :**
- **SYN Flood** : Limite les nouvelles connexions TCP
- **ICMP/Ping Flood** : Limite les requêtes ping
- **UDP Flood** : Limite les paquets UDP
- **Port Scanning** : Détecte et bloque les scans de ports
- **Connexions massives** : Limite les connexions simultanées par IP
- **Fragmentation IP** : Bloque les attaques par fragmentation
- **TCP Options invalides** : Bloque les paquets malformés

### Configuration des ports autorisés

```yaml
ufw_whitelisted_in_ports_base:
  - { to_port: 22, proto: tcp, from_ip: "192.168.1.0/24" }  # SSH depuis un réseau spécifique
  - { to_port: 80, proto: tcp }                             # HTTP depuis n'importe où
  - { to_port: 443 }                                        # HTTPS, tout protocole

ufw_whitelisted_in_ports_extra:
  - { to_port: 8080, proto: tcp, from_ip: "10.0.0.1" }     # Règles supplémentaires
```

### Blocage d'adresses IP

```yaml
ufw_blacklisted_ips:
  - "192.168.1.100"
  - "10.0.0.50"
```

### Configuration Docker

```yaml
ufw_docker_enabled: true  # Active la configuration Docker
```

## Exemple d'utilisation

```yaml
- hosts: all
  become: yes
  roles:
    - role: firewall
      vars:
        ufw_enabled: true
        ufw_docker_enabled: true
        ufw_whitelisted_in_ports_base:
          - { to_port: 22, proto: tcp, from_ip: "{{ ansible_default_ipv4.network }}/24" }
          - { to_port: 80, proto: tcp }
          - { to_port: 443, proto: tcp }
        ufw_blacklisted_ips:
          - "192.168.1.100"
```

## Compatibilité

- Debian 11+ (Bullseye)
- Ubuntu 20.04+ (Focal)

## Notes

- Le rôle est optimisé pour être idempotent et rapide lors d'exécutions multiples
- Les règles Docker sont automatiquement configurées si `ufw_docker_enabled` est activé
- Un backup automatique est créé avant toute modification des fichiers de règles
