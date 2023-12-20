# Minikube Host on a Photon OS VM
<img width="300" alt="MyLogo" src="https://github.com/rafaelurrutiasilva/images/blob/main/logos/MinikubeOnPhotonOS.svg" align=left><br>
<br>
Titel på dokumentet<br>
Författare<br>
Publiceringsdatum<br>

<br>

## Abstract
Kort sammanfattning av dokumentet

## Table of Contents
1. [Introduction](#introduction)
2. [Goals and Objectives](#goals-and-objectives)
3. [Method](#method)
4. [Target Audience](#target-audience)
5. [Document Status](#document-status)
6. [Disclaimer](#disclaimer)
7. [Scope and Limitations](#scope-and-limitations)
8. [Environment](#environment)
9. [Acknowledgments](#acknowledgments)
10. [References](#references)
11. [Conclusion](#conclusion)
12. [Making the Minikube Host](#making-the-minikube-host)
    1. [Basic Configuration of the Photon OS VM](#basic-configuration-of-the-photon-os-vm)
    2. Docker Post-installation
    3. Installing Minikube and kubectl
    4. Test start the cluster
13. 


## Introduction
Inledning
Bakgrund och syfte. Eventuell översiktbild här.

## Goals and Objectives
Mål och syften

## Method
Hur vi gjorde det. Tillvägagångssätt. Vårt sätt

## Target Audience
Målgrupp

## Document Status
> [!NOTE]  
> My work here is not finished yet. I need, among other things, to supplement with instructions on how each component should be configured to work together as well supplement with an overview image that explains how the whole thing works.


## Disclaimer
Ansvarsfriskrivning. Tex:
> [!CAUTION]
> This is intended for learning, testing, and experimentation. The emphasis is not on security or creating an operational environment suitable for production.

## Scope and Limitations
Omfattning och begränsningar

## Environment
> [!TIP]
> The following computer environment was utilized. For details regarding container image versions and other components, please refer to the respective sections in the application documentation available here.
```
Microsoft Windows 10 Enterprise, OS : Version 10.0.19045 N/A Build 19045
VMware Workstation 17 Pro: Version 17.5.0 build-22583795
VMware Photon OS: Version 5.0
Docker Client Engine - Community: Version 24.0.5, API version: 1.43, Go version: go1.20.10
Docker Server Engine - Community: Version 24.0.5, API version: 1.43, Go version: go1.20.10
Virtual Machine: 2vCPU, 8GB vRAM, 50 GB vDisk
Minikube version: v1.32.0
Kubectl Client Version: v1.29.0
```

## Acknowledgments
Big thanks to all the people involved in the material I refer to in my links! I would also like to express gratitude to everyone out there, including my colleagues and friends, who are creating things that help and inspire us to continue learning and exploring this never-ending world of computer technology.

## References
Referenser (om det behövs)

## Conclusion
Slutsats

## Making the Minikube Host
### Basic Configuration of the Photon OS VM
Setting *hostname*, running *update*, installing *sudo* and creating the user *labuser*. 
```
hostnamectl hostname minikubeHost                                                             
tdnf update -y
tdnf install sudo -y
```

### Docker Post-installation
https://docs.docker.com/engine/install/linux-postinstall/
```
systemctl enable docker
systemctl start docker
useradd  -m labuser
usermod -aG docker labuser 
```
Verify that the user *labuser* can run docker. 
```
sudo -u labuser docker run hello-world
```

### Installing Minikube and kubectl
https://minikube.sigs.k8s.io/docs/start/ <br>
Installing latest *minikube* stable releas.
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install -m 755 minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```
Installing latest *kubectl* stable releas.
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
```
### Test start the cluster
Login as *labuser* and start minikube:
```
sudo -iu labuser
minikube start
```
Checking the cluster status:
```
minikube status
```
## Interacting with the cluster
## Deploying hello-minikube
Test to deaploy the first application, *hello-minikube* and expose it on port 8080
```
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```
Check the deployment, it will soon show up when the fallowing command is run.
```
kubectl get services hello-minikube
```
Let minikube give us access this service.
```
minikube service hello-minikube
```
This will show a URL information that can be used for test localy in the Minikube Host
```
curl http://192.168.49.2:30935
```
## Enabling port forwarding
### Firewall configuration
Use *kubectl* to forward the port. For this to work, configure the desired port on the Minikube Host firewall using root privileges. Make sure the port chosen is a higher number, so *labuser* can do the port forwarding
```
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
iptables-save > /etc/systemd/scripts/ip4save
```
### Using port forwarding via kubectl 
Log in as the *labuser* and initiate port forwarding using the kubectl command. You should then be able to browse to the IP address of the Minikube Host VM and the forwarded port.
```
minikubeHostIP=$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')
kubectl port-forward --address $minikubeHostIP service/hello-minikube 8080:8080
```
