hostname RouterSiteA

# Interface principale pour SwPrincipal
interface gigabitEthernet 0/0/0
 no ip address
 no shutdown
exit

# Sous-interfaces pour SwPrincipal - VLAN Direction
interface gigabitEthernet 0/0/0.10
 description SwPrincipal-VLAN10-Direction
 encapsulation dot1Q 10
 ip address 192.168.10.254 255.255.255.240
 ip nat inside
 no shutdown
exit

# Sous-interface pour SwPrincipal - VLAN Technique
interface gigabitEthernet 0/0/0.20
 description SwPrincipal-VLAN20-Technique
 encapsulation dot1Q 20
 ip address 192.168.20.254 255.255.255.224
 ip nat inside
 no shutdown
exit

# Sous-interface pour SwPrincipal - VLAN Commercial
interface gigabitEthernet 0/0/0.30
 description SwPrincipal-VLAN30-Commercial
 encapsulation dot1Q 30
 ip address 192.168.30.254 255.255.255.224
 ip nat inside
 no shutdown
exit

# Sous-interface pour SwPrincipal - VLAN DMZ
interface gigabitEthernet 0/0/0.50
 description SwPrincipal-VLAN50-DMZ
 encapsulation dot1Q 50
 ip address 192.168.50.253 255.255.255.252
 ip nat inside
 no shutdown
exit

# Interface pour SwSecours (sur une autre interface physique)
interface gigabitEthernet 0/0/2
 description TRUNK-to-SwSecours
 no ip address
 no shutdown
exit

# ✅ SOUS-INTERFACES DÉDIÉES pour SwSecours
interface gigabitEthernet 0/0/2.10
 description SwSecours-VLAN10-Direction
 encapsulation dot1Q 10
 ip address 192.168.10.253 255.255.255.240
 ip nat inside
 no shutdown
exit

interface gigabitEthernet 0/0/2.20
 description SwSecours-VLAN20-Technique
 encapsulation dot1Q 20
 ip address 192.168.20.253 255.255.255.224
 ip nat inside
 no shutdown
exit

interface gigabitEthernet 0/0/2.30
 description SwSecours-VLAN30-Commercial
 encapsulation dot1Q 30
 ip address 192.168.30.253 255.255.255.224
 ip nat inside
 no shutdown
exit

interface gigabitEthernet 0/0/2.50
 description SwSecours-VLAN50-DMZ
 encapsulation dot1Q 50
 ip address 192.168.50.252 255.255.255.252
 ip nat inside
 no shutdown
exit

# Sous-interface Management pour les deux switches
interface gigabitEthernet 0/0/0.99
 description Management-SwPrincipal
 encapsulation dot1Q 99
 ip address 192.168.99.1 255.255.255.0
 ip nat inside
 no shutdown
exit

interface gigabitEthernet 0/0/2.99
 description Management-SwSecours
 encapsulation dot1Q 99
 ip address 192.168.99.2 255.255.255.0
 ip nat inside
 no shutdown
exit

# Interface WAN
interface gigabitEthernet 0/0/1
 ip address 80.10.20.2 255.255.255.248
 ip nat outside
 no shutdown
exit

# Configuration DHCP
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
 default-router 192.168.10.254 192.168.10.253
 dns-server 8.8.8.8
exit

ip dhcp pool Technique
 network 192.168.20.224 255.255.255.224
 default-router 192.168.20.254 192.168.20.253
 dns-server 8.8.8.8
exit

ip dhcp pool Commercial
 network 192.168.30.224 255.255.255.224
 default-router 192.168.30.254 192.168.30.253
 dns-server 8.8.8.8
exit

# Routes et NAT
ip route 0.0.0.0 0.0.0.0 80.10.20.1

ip access-list standard Natter
 permit 192.168.10.240 0.0.0.15
 permit 192.168.20.224 0.0.0.31
 permit 192.168.30.224 0.0.0.31
 permit 192.168.50.252 0.0.0.3
exit

ip nat inside source list Natter interface gigabitEthernet 0/0/1 overload
ip nat inside source static tcp 192.168.50.254 80 80.10.20.2 80

# ACL
ip access-list extended ACL_BLOC_COMM
 deny icmp 192.168.30.224 0.0.0.31 192.168.10.240 0.0.0.15 echo
 permit ip any any
exit

interface gigabitEthernet 0/0/0.30
 ip access-group ACL_BLOC_COMM in
exit

interface gigabitEthernet 0/0/2.30
 ip access-group ACL_BLOC_COMM in
exit

no ip nat inside source static tcp 192.168.50.254 80 80.10.20.2 80
ip nat inside source static tcp 192.168.50.254 80 80.10.20.2 80 extendable