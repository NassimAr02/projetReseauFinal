hostname RouterSiteA-Backup

! Interface vers Switch Secours
interface gigabitEthernet 0/0/1
 no ip address
 no shutdown
exit

! Sous-interfaces pour VLANs avec HSRP
interface gigabitEthernet 0/0/1.10
 encapsulation dot1Q 10
 ip address 192.168.10.253 255.255.255.240
 ip nat inside
 standby 10 ip 192.168.10.252
 standby 10 priority 90
 standby 10 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/1.20
 encapsulation dot1Q 20
 ip address 192.168.20.253 255.255.255.224
 ip nat inside
 standby 20 ip 192.168.20.252
 standby 20 priority 90
 standby 20 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/1.30
 encapsulation dot1Q 30
 ip address 192.168.30.253 255.255.255.224
 ip nat inside
 standby 30 ip 192.168.30.252
 standby 30 priority 90
 standby 30 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/1.50
 encapsulation dot1Q 50
 ip address 192.168.50.252 255.255.255.252
 ip nat inside
 standby 50 ip 192.168.50.251
 standby 50 priority 90
 standby 50 preempt
 no shutdown
exit

interface gigabitEthernet 0/0/1.99
 encapsulation dot1Q 99
 ip address 192.168.99.2 255.255.255.0
 ip nat inside
 standby 99 ip 192.168.99.254
 standby 99 priority 90
 standby 99 preempt
 no shutdown
exit

! Lien vers Router1
interface gigabitEthernet 0/0/0
 ip address 10.0.0.2 255.255.255.252
 no shutdown
exit

! Interface WAN de secours
interface gigabitEthernet 0/2/3
 ip address 80.10.20.3 255.255.255.248
 ip nat outside
 no shutdown
exit

! Routes
ip route 0.0.0.0 0.0.0.0 80.10.20.1 200
ip route 192.168.99.0 255.255.255.0 10.0.0.1

! NAT
ip access-list standard Natter
 permit 192.168.10.240 0.0.0.15
 permit 192.168.20.224 0.0.0.31
 permit 192.168.30.224 0.0.0.31
 permit 192.168.50.252 0.0.0.3
exit

ip nat inside source list Natter interface gigabitEthernet 0/2/3 overload
ip nat inside source static tcp 192.168.50.254 80 interface gigabitEthernet 0/2/3 80

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

interface gigabitEthernet 0/0/1.30
 ip access-group ACL_BLOC_COMM in
exit