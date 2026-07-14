# CloudSec CLI Security Report

## System Information

Hostname: Shonis-MacBook-Pro.local

User: shonishindhu

Scan Date: Tue Jul 14 20:25:00 IST 2026

---

## Overall Security

Risk Score: 65 / 100

Risk Level: HIGH RISK

Compliance:
4 / 7
(57%)

Grade:
F

---

## System Health

Disk Usage:
7%

Memory Usage:
0%

Open Ports:
9

---

## Linux Security

Failed Logins:
0

Firewall:
ENABLED

Root Login:
DISABLED

Password Policy:
UNKNOWN

World Writable Files:
0

Inactive Users:
129

SSH Password Authentication:
DISABLED

---

## Docker

Docker:
RUNNING

Running Containers:
0

Privileged Containers:
0

Root Containers:
0

Published Ports:
0

---

## AWS

AWS:
CONNECTED

Account:
806525742801

Running EC2:
0

Running RDS:
0

Elastic IPs:
0

NAT Gateways:
0

---

## Kubernetes

Cluster:
CONNECTED

Running Pods:
9

Privileged Pods:
1

---

## Risk Distribution

System Health:
20

Linux:
5

Docker:
0

AWS:
0

Kubernetes:
25

---

## Executive Summary

CloudSec detected a **HIGH RISK** environment.

---

## Compliance Report

Firewall:
PASS

Root Login:
PASS

SSH Password Authentication:
FAIL

Password Policy:
FAIL

World Writable Files:
PASS

Docker:
PASS

Kubernetes:
FAIL

---

## Remediation


           ☸️ Privileged Kubernetes Pods
           Severity: CRITICAL
           Risk: Containers can escape normal security restrictions.
           Fix:
           
kubectl edit deployment 

securityContext:
  privileged: false
           
           

📦 Outdated Packages

Severity: HIGH

Install the latest security patches.


sudo apt update
sudo apt upgrade

