# **The Book of Nerd**

## **Networking Research Task**

---

## **Networking**

---

### **Devices**

#### **Routers**

A router is a device which receives and forwards data packets transmitted within a network. Routers determine where the data goes, whether its destination is within a network, or if it needs to be transferred to another network. Routers are mainly used as a means of connecting a local network, to other networks.

#### **Switches**

Like a router, a network switch is a device which directs traffic to and from devices on a network. The main difference between a router and a switch is that switches are mainly used within a network, whereas routers are mainly used to communicate between networks. Switches, hubs and routers may be built into a single device.

#### **Gateways**

A gateway is a node (router) in a computer network where data passes on its way in or out of a network. It is where the data is read/used. It figures out the destination of the data and transmits it to that node.

#### **Repeaters**

Repeaters are network devices which amplify/reconstruct signals in order to send it to further physical distances. Analog repeaters only amplify this signal, whereas digital repeaters reconstruct the signal close to the original quality.

### **Servers**

#### **File**

A file server in a network is a system which acts as a repository of data which is used by programs and other users on the network.

#### **Web**

A web server is a system which serves data to users over the internet. Any internet server that responds to HTTP(S) requests are classified as a web server.

#### **Database**

A database server is a type of storage server which serves data from databases (structured sets of data which are stored in database files).

#### **Proxy**

A proxy server is an alternate path for a client to connect to a server/the internet. It reroutes the internet request so that your real IP address is masked.

#### **Print**

A print server is a software or device on a network which manages print requests, and and serves them to printers on the network.

### **Network Topologies**

#### **Ring**

A ring network is a network of devices where every node is connected in a single continuous pathway. Data only travels in one direction (i.e. From A to B to C etc. but not from C to B to A), which means for data to travel from C to A, it would have to go through any other nodes in the forward direction (i.e. it will have to travel through D, E, F, etc. all the way around to A). This may result in lower speeds, but collisions are eliminated in this network, reducing chances for corruption,however should one node fail, the network can be brought down.

#### **Ethernet/Bus**

Ethernet/bus networks have a single stream of data which connects all the nodes on the network. Incoming collisions are eliminated through the use of special functions to reduce chances of corruption. Speeds can be negotiated, and requests are queued to allow for simultaneous use of the network. It is the most common topology in networking.

#### **Star**

A star topology is a LAN topology where all nodes are connected individually to a central node. The central node processes and distributes the requests to the other nodes. Whilst it may require more cables, it offers more redundancy in that should one node fail, it will affect the other nodes on the network.

#### **Mesh**

A mesh network is a local network topology where each individual node is connected by multiple routes, which can be dynamically used. When every node in a mesh network is connected, it is a fully complete network.

#### **Hybrid**

A Hybrid Network is where a combination of topologies are used in order to create a purpose built network. Examples may include using an Ethernet topology inside buildings, and having the buildings connected by a mesh network.

### **Network Types**

#### **LAN**

Local Area Network (LAN) is a network which connects devices in a limited space, such as a building or cluster of buildings.

#### **WAN**

Wide Area Network (WAN) is a network which connects multiple LAN networks. An example would be a network which connects a company's headquarters and it's brand offices.

#### **SAN**

A Storage Area Network (SAN) is a secure high-speed network which allows for access to storage servers. SAN devices appear as attached drives, thus reducing networking bottlenecks.

#### **CAN**

A Campus Area Network (CAN), not to be confused with controller area networks (a bus design), is a network which connects multiple LAN networks in a small space. It is similar to a WAN network, however it is smaller.

#### **MAN**

A metropolitan area network (MAN), is a network which connects multiple computer resources in a geographical size which is much larger than a CAN or WAN. An example of a MAN would be the network of a city.

### **Protocols**

#### **TCP/IP**

Transmission Control Protocol/Internet Protocol is a protocol which allows for devices to communicate on a network. It is non-proprietary, so it can be used worldwide, being a global network standard.

#### **SSL**

Secure Socket Layer (SSL) is an encryption protocol used by the HTTPS protocol in order to protect the data transmitted. It encrypts the data during transmissions, protecting it from attackers. An SSL certificate is needed for HTTPS, in order to verify the identity of the web server. This verification is done via an SSL handshake.

#### **HTTP/HTTPS**

Hypertext Transfer Protocol, is a protocol for transmitting and formatting web requests. Web servers receive and transmit data from an HTTP request, which tells it how to format and transmit the data. Hypertext Transfer Protocol Secure is almost the same as HTTP, except that the data transmitted is secured using encryption protocols (usually SSL or TLS). This prevents attackers from snooping and/or injecting code into the request.

#### **FTP**

File Transfer Protocol (FTP) is a protocol used to transfer files onto a remote server. The secure variant is SFTP (Secure File Transfer Protocol). It can be authenticated by username and password or via ssh/pubkeys.

---

## **Bibliography**

---

<https://www.techopedia.com/definition/2277/router>  
<https://www.diffen.com/difference/Router_vs_Switch>  
<https://whatismyipaddress.com/gateway>  
<https://computer.howstuffworks.com/what-is-network-server.htm>  
<https://www.webopedia.com/TERM/R/repeater.html>  
<https://www.lifewire.com/what-is-a-file-2625878>  
<https://www.techopedia.com/definition/441/database-server>  
<https://whatismyipaddress.com/proxy-server>  
<https://www.black-box.de/en-de/page/21072/Resources/Technical-Resources/Technology-Overview/Ethernet-Topologies>  
<http://www.telecomabc.com/s/star.html>  
<https://www.webopedia.com/TERM/H/HTTP.html>  
<https://www.instantssl.com/ssl-certificate-products/https.html>  
<https://www.instantssl.com/ssl.html>  
<https://searchnetworking.techtarget.com/definition/TCP-IP>  
<https://searchenterprisewan.techtarget.com/definition/WAN>  
<https://searchnetworking.techtarget.com/definition/metropolitan-area-network-MAN>  

---
