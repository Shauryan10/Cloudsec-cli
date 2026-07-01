# CloudSec CLI Security Report

## System Information

Hostname: Shonis-MacBook-Pro.local

User: shonishindhu

Scan Date: Wed Jul  1 20:50:30 IST 2026

---

## Overall Security

Risk Score: 45 / 100

Risk Level: MEDIUM RISK

Compliance:
4 / 7
(57%)

Grade:
F

---

## System Health

Disk Usage:
6%

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
INSTALLED BUT NOT RUNNING

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
5

Docker:
5

AWS:
0

Kubernetes:
0

---

## Executive Summary

CloudSec detected a **MEDIUM RISK** environment.

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
N/A

---

## Remediation



📦 Outdated Packages

Severity: HIGH

Install the latest security patches.


sudo apt update
sudo apt upgrade

