hostname RouterSiteA-Primary

! Interface WAN principale
interface gigabitEthernet 0/0/1
 ip address 80.10.20.2 255.255.255.248
 ip nat outside
 no shutdown
exit

! Interface vers Switch Principal
interface gigabitEthernet 0/0/0
 no ip address
 no shutdown
exit

! Sous-interfaces pour VLANs avec HSRP
interface gigabitEthernet 0/0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.254 255.255.255.240
 ip nat inside
 standby 10 ip 192.168.10.252
 standby 10 priority 110
 standby 10 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.254 255.255.255.224
 ip nat inside
 standby 20 ip 192.168.20.252
 standby 20 priority 110
 standby 20 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.254 255.255.255.224
 ip nat inside
 standby 30 ip 192.168.30.252
 standby 30 priority 110
 standby 30 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/0.50
 encapsulation dot1Q 50
 ip address 192.168.50.253 255.255.255.252
 ip nat inside
 standby 50 ip 192.168.50.251
 standby 50 priority 110
 standby 50 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/0.99
 encapsulation dot1Q 99
 ip address 192.168.99.1 255.255.255.0
 ip nat inside
 standby 99 ip 192.168.99.254
 standby 99 priority 110
 standby 99 preempt
 no shutdown
exit

! Lien vers Router2 (Backup)
interface gigabitEthernet 0/2/0
 ip address 10.0.0.1 255.255.255.252
 no shutdown
exit

! Routes
ip route 0.0.0.0 0.0.0.0 80.10.20.1
ip route 192.168.99.0 255.255.255.0 10.0.0.2

! NAT
ip access-list standard Natter
 permit 192.168.10.240 0.0.0.15
 permit 192.168.20.224 0.0.0.31
 permit 192.168.30.224 0.0.0.31
 permit 192.168.50.252 0.0.0.3
exit

ip nat inside source list Natter interface gigabitEthernet 0/0/1 overload
ip nat inside source static tcp 192.168.50.254 80 interface gigabitEthernet 0/0/1 80

! DHCP
ip dhcp excluded-address 192.168.10.254
ip dhcp excluded-address 192.168.10.253
ip dhcp excluded-address 192.168.20.254
ip dhcp excluded-address 192.168.20.253
ip dhcp excluded-address 192.168.30.254
ip dhcp excluded-address 192.168.30.253
ip dhcp excluded-address 192.168.50.253
ip dhcp excluded-address 192.168.50.252

ip dhcp pool Direction
 network 192.168.10.240 255.255.255.240
 default-router 192.168.10.252
 dns-server 8.8.8.8
exit

ip dhcp pool Technique
 network 192.168.20.224 255.255.255.224
 default-router 192.168.20.252
 dns-server 8.8.8.8
exit

ip dhcp pool Commercial
 network 192.168.30.224 255.255.255.224
 default-router 192.168.30.252
 dns-server 8.8.8.8
exit

! ACL
ip access-list extended ACL_BLOC_COMM
 deny icmp 192.168.30.224 0.0.0.31 192.168.10.240 0.0.0.15 echo
 permit ip any any
exit

interface gigabitEthernet 0/0/0.30
 ip access-group ACL_BLOC_COMM in
exit

######################♦ SWITCH
hostname SwPrincipal

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

! Trunk vers Router1 Principal
interface gigabitEthernet 1/0/21
 description TRUNK-to-Router1-G0/0/0
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,50,99
 no shutdown
exit

! Trunk vers SwSecours
interface gigabitEthernet 1/0/23
 description TRUNK-to-SwSecours
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,50,99
 no shutdown
exit

! Ports d'accès Commercial (VLAN 30)
interface range gigabitEthernet 1/0/2-6
 switchport mode access
 switchport access vlan 30
 no shutdown
exit

! Ports d'accès Technique (VLAN 20)
interface range gigabitEthernet 1/0/7-13
 switchport mode access
 switchport access vlan 20
 no shutdown
exit

! Ports d'accès Direction (VLAN 10)
interface range gigabitEthernet 1/0/14-16
 switchport mode access
 switchport access vlan 10
 no shutdown
exit

! Port DMZ (VLAN 50)
interface gigabitEthernet 1/0/24
 switchport mode access
 switchport access vlan 50
 no shutdown
exit

! Management
interface vlan 99
 ip address 192.168.99.10 255.255.255.0
 no shutdown
exit

ip default-gateway 192.168.99.254