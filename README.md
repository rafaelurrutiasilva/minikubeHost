# Title Page
<img width="100" alt="MyLogo" src="https://github.com/rafaelurrutiasilva/images/blob/main/logos/MyLogo_2.png" align=left><br>
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
Miljö som användes

## Acknowledgments
Tack och erkännanden. Tex:
Big thanks to all the people involved in the material I refer to in my links! I would also like to express gratitude to everyone out there, including my colleagues and friends, who are creating things that help and inspire us to continue learning and exploring this never-ending world of computer technology.

## References
Referenser (om det behövs)

## Conclusion
Slutsats

## Making the Minikube Host
### Basic Configuration of the Photon OS VM
```
hostnamectl hostname minikubeHost                                                              # Setting the hostname to minikubeHost
tdnf update -y
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64          # Using the latest minikube stable releas
install -m 755 minikube-linux-amd64 /usr/local/bin/minikube
tdnf install tar jq git docker-compose
```
