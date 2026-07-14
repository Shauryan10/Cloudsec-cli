# CloudSec CLI Security Report

## System Information

Hostname: docker-desktop

User: root

Scan Date: Tue Jul 14 14:35:32 UTC 2026

---

## Overall Security

Risk Score: 125 / 100

Risk Level: HIGH RISK

Compliance:
1 / 7
(14%)

Grade:
F

---

## System Health

Disk Usage:
6%

Memory Usage:
18%

Open Ports:
21

---

## Linux Security

Failed Logins:
0

Firewall:
DISABLED

Root Login:
UNKNOWN

Password Policy:
WEAK

World Writable Files:
0

Inactive Users:
18

SSH Password Authentication:
UNKNOWN

---

## Docker

Docker:
RUNNING

Running Containers:
1

Privileged Containers:
1

Root Containers:
1

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
40

Docker:
40

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
FAIL

Root Login:
FAIL

SSH Password Authentication:
FAIL

Password Policy:
FAIL

World Writable Files:
PASS

Docker:
FAIL

Kubernetes:
FAIL

---

## Remediation


        🚨 Firewall Disabled
        Severity: HIGH
        Risk: Incoming connections are not filtered.
        Fix:
        
sudo ufw enable
        
        Verify:
        
sudo ufw status
        
        
           ☸️ Privileged Kubernetes Pods
           Severity: CRITICAL
           Risk: Containers can escape normal security restrictions.
           Fix:
           
kubectl edit deployment 

securityContext:
  privileged: false
           
           
        ⚠ Weak Password Policy
        Severity: HIGH
        Risk: Passwords may never expire.
        Fix:
        
        sudo nano /etc/login.defs

        PASS_MAX_DAYS 90
        PASS_MIN_DAYS 1
        PASS_WARN_AGE 7
        
        Verify:
        
        grep PASS_MAX_DAYS /etc/login.defs
        
        

