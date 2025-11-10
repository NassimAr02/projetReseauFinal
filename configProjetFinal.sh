hostname SwPrincipal

vlan 10
 name Direction
exit
vlan 20         
 name Technique
exit
vlan 30
 name Commercial
exit

interface range gigabitEthernet 1/0/2-6
 switchport mode access
 switchport access vlan 30
 no shutdown
exit    
interface range gigabitEthernet 1/0/7-13
 switchport mode access
 switchport access vlan 20
 no shutdown
exit
interface range gigabitEthernet 1/0/14-16
 switchport mode access
 switchport access vlan 10
 no shutdown
exit    

ip routing

interface gigabitEthernet 1/0/1
 switchport mode trunk
 no shutdown
exit

# Configuration des interfaces VLAN
interface vlan 10
 ip address 192.168.10.254 255.255.255.248
 no shutdown
exit

interface vlan 20
 ip address 192.168.20.254 255.255.255.240
 no shutdown
exit

interface vlan 30
 ip address 192.168.30.254 255.255.255.240
 no shutdown
exit
# Configuration DHCP (doit être en mode configuration globale)
ip dhcp pool Direction
 network 192.168.10.248 255.255.255.248
 default-router 192.168.10.254
 dns-server 8.8.8.8
exit

ip dhcp pool Technique
 network 192.168.20.240 255.255.255.240
 default-router 192.168.20.254
 dns-server 8.8.8.8
exit

ip dhcp pool Commercial
 network 192.168.30.240 255.255.255.240
 default-router 192.168.30.254
 dns-server 8.8.8.8
exit