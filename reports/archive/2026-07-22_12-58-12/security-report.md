# CloudSec CLI Security Report

## System Information

Hostname: docker-desktop

User: root

Scan Date: Wed Jul 22 12:58:08 UTC 2026

---

## Overall Security

Risk Score: 85 / 100

Risk Level: HIGH RISK

Compliance:
1 / 7
(14%)

Grade:
F

---

## System Health

Disk Usage:
7%

Memory Usage:
18%

Open Ports:
22

---

## Linux Security

Failed Logins:
0

Firewall:
NOT FOUND

Root Login:
UNKNOWN

Password Policy:
WEAK

World Writable Files:
0

Inactive Users:
19

SSH Password Authentication:
UNKNOWN

---

## Docker

Docker:
RUNNING

Running Containers:
2

Privileged Containers:
1

Root Containers:
2

Published Ports:
2

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
NOT INSTALLED

Running Pods:
0

Privileged Pods:
0

---

## Risk Distribution

System Health:
20

Linux:
25

Docker:
40

AWS:
0

Kubernetes:
0

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
N/A

---

## Remediation


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
        
        

