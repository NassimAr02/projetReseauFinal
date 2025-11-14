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
interface gigabitEthernet 1/0/1
 no switchport
 ip address 192.168.99.2 255.255.255.248
 no shutdown
exit    

ip dhcp excluded-address 192.168.10.254
ip dhcp excluded-address 192.168.20.254
ip dhcp excluded-address 192.168.30.254
ip dhcp excluded-address 192.168.50.253


ip route 0.0.0.0 0.0.0.0 192.168.99.1

no ip access-list extended ACL_BLOC_COMM
ip access-list extended ACL_BLOC_COMM
 deny icmp 192.168.30.240 0.0.0.15 192.168.10.248 0.0.0.7 echo
 permit ip any any
exit
interface vlan 30
 ip access-group ACL_BLOC_COMM in
exit
#################### Configuration du router ####################
hostname RouterSiteA

interface gigabitEthernet 0/0/0
 no shutdown
 ip address 192.168.99.1 255.255.255.248
exit

ip route 192.168.10.248 255.255.255.248 192.168.99.2
ip route 192.168.20.240 255.255.255.240 192.168.99.2
ip route 192.168.30.240 255.255.255.240 192.168.99.2
ip route 192.168.50.252 255.255.255.252 192.168.99.2
#################### Configuration du  NAT ####################
interface gigabitEthernet 0/0/1
 ip address 80.10.20.2 255.255.255.252
 ip nat outside
 no shutdown
exit
ip route 0.0.0.0 0.0.0.0 80.10.20.1

interface gigabitEthernet 0/0/0
 ip nat inside
 no shutdown
exit

ip access-list standard Natter
 permit 192.168.10.248 0.0.0.7
 permit 192.168.20.240 0.0.0.15
 permit 192.168.30.240 0.0.0.15
 permit 192.168.50.252 0.0.0.3
exit

ip nat inside source list Natter interface gigabitEthernet 0/0/1 overload
##################### Configuration DMZ sur le switch ####################
vlan 50
 name DMZ
exit

interface gigabitEthernet 1/0/24
 switchport mode access
 switchport access vlan 50
 no shutdown
exit

interface vlan 50
 ip address 192.168.50.253 255.255.255.252
 no shutdown
exit


# paramètrage accès DMZ
ip nat inside source static tcp 192.168.50.254 80 80.10.20.1 80


