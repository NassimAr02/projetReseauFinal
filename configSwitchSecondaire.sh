hostname SwSecours

! Configuration des VLANs
vlan 10
 name Direction
exit
vlan 20
 name Technique
exit
vlan 30
 name Commercial
exit
vlan 50
 name DMZ
exit
vlan 99
 name Management
exit

! Trunk vers Router2 Backup
interface gigabitEthernet 1/0/21
 description TRUNK-to-Router2-G0/0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,50,99
 shutdown  ! Désactivé en attente
exit

! Trunk vers SwPrincipal
interface gigabitEthernet 1/0/23
 description TRUNK-to-SwPrincipal
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,50,99
 no shutdown
exit

! Ports d'accès Commercial (VLAN 30)
interface range gigabitEthernet 1/0/2-6
 switchport mode access
 switchport access vlan 30
 shutdown
exit

! Ports d'accès Technique (VLAN 20)
interface range gigabitEthernet 1/0/7-13
 switchport mode access
 switchport access vlan 20
 shutdown
exit

! Ports d'accès Direction (VLAN 10)
interface range gigabitEthernet 1/0/14-16
 switchport mode access
 switchport access vlan 10
 shutdown
exit

! Port DMZ (VLAN 50)
interface gigabitEthernet 1/0/24
 switchport mode access
 switchport access vlan 50
 shutdown
exit

! Management
interface vlan 99
 ip address 192.168.99.11 255.255.255.0
 no shutdown
exit

ip default-gateway 192.168.99.254