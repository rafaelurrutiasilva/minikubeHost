# Minikube Host on a Photon OS VM
<img width="300" alt="MyLogo" src="https://github.com/rafaelurrutiasilva/images/blob/main/logos/MinikubeOnPhotonOS.svg" align=left><br>
Minikube is a lightweight Kubernetes implementation that creates a VM on your local machine and deploys a simple cluster containing only one node. 
<br>
<br>
<br>
<br>


## Abstract
I have been developing a [Container Host using a Photon OS VM](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker) to conduct tests with Grafana, Prometheus, and metrics sourced from Harbor. Currently, I am applying this expertise to establish a Minikube Host on the same operating system, serving as the groundwork for diverse deployments within my Kubernetes cluster (Minikube).

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
    5. Checking the cluster status
13. Interacting with the cluster
    1. Deploying hello-minikube
    2. Checking the deployment
    3. Giving access to service
14. Enabling port forwarding
    1. Firewall configuration
    2. Using port forwarding via kubectl
15. Clean up and stop Minikube
16. 
17. Next - Hello Minikube

## Introduction
[Kubernetes](https://kubernetes.io/docs/concepts/overview/) is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. [Minikube](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro) can be the ideal learning platform when delivering Kubernetes training. The [Photon OS](https://vmware.github.io/photon/) is a Linux based, open source, security-hardened, enterprise grade appliance operating system that is purpose built for Cloud and Edge applications.<br>
I thought that the combination of a Virtual Machine created with Photon OS and Minikube installed would be the perfect lab environment for my journey in learning Kubernetes. The benefit of setting up a VM with all necessary lab components is the ability to easily prepare and store it as a template or OVA file. This streamlines the process of creating VMs for future use. After completing the lab, the VM can be deleted, ready to be recreated when needed again.

## Goals and Objectives
Create a Minikube Host VM based on Photon OS. The VM should be equipped with all the necessary tools to interact with Kubernetes clusters (Minikube) and should be easily reproducible as needed. Document all the required steps and instructions thoroughly.

## Method
I begin by downloading a [OVA-file for Photon OS](https://github.com/vmware/photon/wiki/Downloading-Photon-OS). I utilize this file to create a VM with the estimated resource configuration required for my labs. Subsequently, I prepare the VM by installing Minikube, Kubectl, Helm, and other tools essential for practical Kubernetes training and learning. The VM will also be saved as a OVA file for easely be used to speen of new VMs. The VM will also be saved as an OVA file for easy duplication and rapid provisioning of new VMs.

## Target Audience
This guide is designed for individuals seeking to explore and gain insights into testing and learning Kubernetes. It is especially tailored for beginners, like myself, who are just starting their journey and need a reliable home platform for doing so.

## Document Status
> [!NOTE]  
> My work here is just started! 


## Disclaimer
> [!CAUTION]
> This is intended for learning, testing, and experimentation. The emphasis is not on security or creating an operational environment suitable for production.

## Scope and Limitations
This guide provides a rapid method to establish a home Kubernetes environment for testing modern applications on a single Minikube Host VM. It is important to note that this guide is not intended for use as a reference in a production environment and does not comprehensively cover all the security considerations required for such an environment.

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
* [Downloading Photon OS](https://github.com/vmware/photon/wiki/Downloading-Photon-OS)
* [Photon OS](https://vmware.github.io/photon/)
* [Container Host using a Photon OS VM](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker)
* [Minikube Start](https://minikube.sigs.k8s.io/docs/start)
* [Minikube Status](https://minikube.sigs.k8s.io/docs/commands/status/#minikube-status)
* [Docker Postinstallation](https://docs.docker.com/engine/install/linux-postinstall)
* [Hello-Minikube](https://kubernetes.io/docs/tutorials/hello-minikube)
* [kubectl to Create a Deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro)
* [Kubernetes](https://kubernetes.io/docs/concepts/overview/)

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
This Docker post-installation is necessary to meet the requirement of starting and running Minikube either as a non-privileged user or by using sudo. In this guide, I create a *labuser*, who runs Minikube throughout all the documented steps.
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
### Checking the cluster status
Gets the status of the local Kubernetes cluster using the command [minikube status](https://minikube.sigs.k8s.io/docs/commands/status/#minikube-status).
```
minikube status
```

## Interacting with the cluster
### Deploying hello-minikube
Test to deaploy the first application, [hello-minikube](https://kubernetes.io/docs/tutorials/hello-minikube) and expose it on port 8080
```
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

### Checking the deployment 
It will soon shows up when the fallowing command is run.
```
kubectl get services hello-minikube
```

### Giving access to service.
Minikube provides access to the actual service by running the command below.
```
minikube service hello-minikube
```

This will display a URL that can be used for local testing within the Minikube host.
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
## Clean up and stop Minikube
Now you can clean up the resources  created in the cluster.
```
kubectl delete service hello-minikube
kubectl delete deployment hello-minikube
minikube stop
```
> [!TIP]
Using *stop* command will stops a local Kubernetes cluster. This command stops the underlying VM or container, but keeps user data intact. The
cluster can be started again with the *start* command.<br>
Using *deletes* command will a local Kubernetes cluster. This command deletes the VM, and removes all associated files.
Use ***minikube options*** for a list of global command-line options (applies to all commands).

## Next - Hello Minikube
> [!TIP]
The [hello-minikube](https://kubernetes.io/docs/tutorials/hello-minikube) tutorial guides you through running a sample app on Kubernetes using Minikube and serves as a good *next step* in exploring Kubernetes.
