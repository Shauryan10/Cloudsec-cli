#!/bin/bash

REPORT_DIR="reports"
TEMPLATE_FILE="templates/report-template.html"
CSS_FILE="templates/style.css"
HTML_REPORT="$REPORT_DIR/security-report.html"

mkdir -p "$REPORT_DIR"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
RESET="\033[0m"

animate_title() {

clear

echo -e "${RED}${BOLD} ██████╗██╗      ██████╗ ██╗   ██╗██████╗ ███████╗███████╗ ██████╗ ${RESET}"
echo -e "${YELLOW}${BOLD}██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝██╔════╝${RESET}"
echo -e "${GREEN}${BOLD}██║     ██║     ██║   ██║██║   ██║██║  ██║███████╗█████╗  ██║     ${RESET}"
echo -e "${CYAN}${BOLD}██║     ██║     ██║   ██║██║   ██║██║  ██║╚════██║██╔══╝  ██║     ${RESET}"
echo -e "${BLUE}${BOLD}╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝███████║███████╗╚██████╗${RESET}"
echo -e "${MAGENTA}${BOLD} ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝${RESET}"

echo ""

echo -e "${RED}${BOLD}                     ██████╗██╗     ██╗${RESET}"
echo -e "${YELLOW}${BOLD}                    ██╔════╝██║     ██║${RESET}"
echo -e "${GREEN}${BOLD}                    ██║     ██║     ██║${RESET}"
echo -e "${CYAN}${BOLD}                    ██║     ██║     ██║${RESET}"
echo -e "${BLUE}${BOLD}                    ╚██████╗███████╗██║${RESET}"
echo -e "${MAGENTA}${BOLD}                     ╚═════╝╚══════╝╚═╝${RESET}"

echo ""
}

show_banner() {

animate_title

echo -e "${YELLOW}${BOLD}══════════════════════════════════════════════════════════════════════════════${RESET}"

echo -e "${GREEN}${BOLD}                    Linux • Cloud Security • Cost Monitoring${RESET}"
echo -e "${CYAN}${BOLD}                     AWS • Docker • DevSecOps • Risk Audit${RESET}"
echo -e "${MAGENTA}${BOLD}                Real-Time Visibility & Security Insights${RESET}"

echo -e "${YELLOW}${BOLD}══════════════════════════════════════════════════════════════════════════════${RESET}"

echo ""
}

get_status() {
    value=$1
    warning=$2
    critical=$3

    if [ "$value" -lt "$warning" ]; then
        echo "OK"
    elif [ "$value" -lt "$critical" ]; then
        echo "WARNING"
    else
        echo "CRITICAL"
    fi
}

get_color() {
    status=$1

    if [ "$status" = "OK" ]; then
        echo "green"
    elif [ "$status" = "WARNING" ]; then
        echo "yellow"
    else
        echo "red"
    fi
}

print_status() {
    label=$1
    value=$2
    status=$3

    if [ "$status" = "OK" ]; then
        echo -e "$label : ${GREEN}${BOLD}$value ✅ OK${RESET}"
    elif [ "$status" = "WARNING" ]; then
        echo -e "$label : ${YELLOW}${BOLD}$value ⚠️ WARNING${RESET}"
    else
        echo -e "$label : ${RED}${BOLD}${UNDERLINE}$value 🚨 CRITICAL${RESET}"
    fi
}

show_banner

HOSTNAME_VALUE=$(hostname)
CURRENT_USER=$(whoami)
SCAN_DATE=$(date)

RISK_SCORE=0

echo -e "${BLUE}${BOLD}System Information${RESET}"
echo "-------------------------------------------------"
echo "Hostname      : $HOSTNAME_VALUE"
echo "Current User  : $CURRENT_USER"
echo "Scan Time     : $SCAN_DATE"
echo ""

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)

if command -v free >/dev/null 2>&1; then
    MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
else
    MEMORY_USAGE=0
fi

if command -v ss >/dev/null 2>&1; then
    OPEN_PORTS=$(ss -tuln | tail -n +2 | wc -l | tr -d ' ')
elif command -v lsof >/dev/null 2>&1; then
    OPEN_PORTS=$(lsof -i -P -n | grep LISTEN | wc -l | tr -d ' ')
else
    OPEN_PORTS=0
fi

DISK_STATUS=$(get_status "$DISK_USAGE" 70 85)
MEMORY_STATUS=$(get_status "$MEMORY_USAGE" 70 85)
PORT_STATUS=$(get_status "$OPEN_PORTS" 5 8)

DISK_COLOR=$(get_color "$DISK_STATUS")
MEMORY_COLOR=$(get_color "$MEMORY_STATUS")
PORT_COLOR=$(get_color "$PORT_STATUS")

if [ "$DISK_STATUS" = "WARNING" ]; then
    RISK_SCORE=$((RISK_SCORE + 10))
elif [ "$DISK_STATUS" = "CRITICAL" ]; then
    RISK_SCORE=$((RISK_SCORE + 25))
fi

if [ "$MEMORY_STATUS" = "WARNING" ]; then
    RISK_SCORE=$((RISK_SCORE + 10))
elif [ "$MEMORY_STATUS" = "CRITICAL" ]; then
    RISK_SCORE=$((RISK_SCORE + 25))
fi

if [ "$PORT_STATUS" = "WARNING" ]; then
    RISK_SCORE=$((RISK_SCORE + 10))
elif [ "$PORT_STATUS" = "CRITICAL" ]; then
    RISK_SCORE=$((RISK_SCORE + 20))
fi

echo -e "${BLUE}${BOLD}System Health${RESET}"
echo "-------------------------------------------------"
print_status "Disk Usage   " "$DISK_USAGE%" "$DISK_STATUS"
print_status "Memory Usage " "$MEMORY_USAGE%" "$MEMORY_STATUS"
echo ""

echo -e "${BLUE}${BOLD}Security Checks${RESET}"
echo "-------------------------------------------------"
print_status "Open Ports   " "$OPEN_PORTS" "$PORT_STATUS"
echo ""

# Day 5 Security Checks

WORLD_WRITABLE=$(find /tmp /var/tmp -type f -perm -0002 2>/dev/null | wc -l | tr -d ' ')
WORLD_WRITABLE_STATUS=$(get_status "$WORLD_WRITABLE" 5 20)
WORLD_WRITABLE_COLOR=$(get_color "$WORLD_WRITABLE_STATUS")

PASSWORD_POLICY="UNKNOWN"
if grep -q "^PASS_MAX_DAYS" /etc/login.defs 2>/dev/null; then
    PASSWORD_POLICY="CONFIGURED"
fi
PASSWORD_POLICY_COLOR="green"

INACTIVE_USERS=$(awk -F: '$7 ~ /(nologin|false)/ {count++} END {print count+0}' /etc/passwd)

SSH_PASSWORD_AUTH="UNKNOWN"
SSH_PASSWORD_COLOR="yellow"

if [ -f /etc/ssh/sshd_config ]; then
    if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
        SSH_PASSWORD_AUTH="DISABLED"
        SSH_PASSWORD_COLOR="green"
    else
        SSH_PASSWORD_AUTH="ENABLED"
        SSH_PASSWORD_COLOR="red"
    fi
fi


echo -e "${BLUE}${BOLD}Linux Security Checks${RESET}"
echo "-------------------------------------------------"

FAILED_LOGINS=0

if [ -f /var/log/auth.log ]; then
    FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l | tr -d ' ')
elif [ -f /var/log/secure ]; then
    FAILED_LOGINS=$(grep "Failed password" /var/log/secure 2>/dev/null | wc -l | tr -d ' ')
else
    FAILED_LOGINS=0
fi

FAILED_LOGIN_STATUS=$(get_status "$FAILED_LOGINS" 3 6)
FAILED_LOGIN_COLOR=$(get_color "$FAILED_LOGIN_STATUS")

if [ "$FAILED_LOGIN_STATUS" = "WARNING" ]; then
    RISK_SCORE=$((RISK_SCORE + 10))
elif [ "$FAILED_LOGIN_STATUS" = "CRITICAL" ]; then
    RISK_SCORE=$((RISK_SCORE + 25))
fi

print_status "Failed Logins" "$FAILED_LOGINS" "$FAILED_LOGIN_STATUS"

echo "World Writable Files : $WORLD_WRITABLE ($WORLD_WRITABLE_STATUS)"
echo "Password Policy      : $PASSWORD_POLICY"
echo "Inactive Users       : $INACTIVE_USERS"
echo "SSH Password Auth    : $SSH_PASSWORD_AUTH"
echo ""


FIREWALL_STATUS="UNKNOWN"
FIREWALL_COLOR="yellow"

if command -v ufw >/dev/null 2>&1; then
    if ufw status 2>/dev/null | grep -q "Status: active"; then
        FIREWALL_STATUS="ENABLED"
        FIREWALL_COLOR="green"
    else
        FIREWALL_STATUS="DISABLED"
        FIREWALL_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 20))
    fi
elif command -v firewall-cmd >/dev/null 2>&1; then
    if firewall-cmd --state 2>/dev/null | grep -q "running"; then
        FIREWALL_STATUS="ENABLED"
        FIREWALL_COLOR="green"
    else
        FIREWALL_STATUS="DISABLED"
        FIREWALL_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 20))
    fi
elif /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate >/dev/null 2>&1; then
    if /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -q "enabled"; then
        FIREWALL_STATUS="ENABLED"
        FIREWALL_COLOR="green"
    else
        FIREWALL_STATUS="DISABLED"
        FIREWALL_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 20))
    fi
else
    FIREWALL_STATUS="NOT FOUND"
    FIREWALL_COLOR="yellow"
    RISK_SCORE=$((RISK_SCORE + 5))
fi

if [ "$FIREWALL_COLOR" = "green" ]; then
    echo -e "Firewall      : ${GREEN}${BOLD}$FIREWALL_STATUS ✅${RESET}"
elif [ "$FIREWALL_COLOR" = "red" ]; then
    echo -e "Firewall      : ${RED}${BOLD}${UNDERLINE}$FIREWALL_STATUS 🚨${RESET}"
else
    echo -e "Firewall      : ${YELLOW}${BOLD}$FIREWALL_STATUS ⚠️${RESET}"
fi


SSH_STATUS="NOT RUNNING"
SSH_COLOR="green"

if pgrep sshd >/dev/null 2>&1; then
    SSH_STATUS="RUNNING"
    SSH_COLOR="yellow"
    RISK_SCORE=$((RISK_SCORE + 5))
fi

if [ "$SSH_COLOR" = "yellow" ]; then
    echo -e "SSH Service   : ${YELLOW}${BOLD}$SSH_STATUS ⚠️${RESET}"
else
    echo -e "SSH Service   : ${GREEN}${BOLD}$SSH_STATUS ✅${RESET}"
fi


ROOT_LOGIN_STATUS="UNKNOWN"
ROOT_LOGIN_COLOR="yellow"

if [ -f /etc/ssh/sshd_config ]; then
    if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
        ROOT_LOGIN_STATUS="ENABLED"
        ROOT_LOGIN_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 25))
    else
        ROOT_LOGIN_STATUS="DISABLED"
        ROOT_LOGIN_COLOR="green"
    fi
fi

if [ "$ROOT_LOGIN_COLOR" = "red" ]; then
    echo -e "Root SSH Login: ${RED}${BOLD}${UNDERLINE}$ROOT_LOGIN_STATUS 🚨${RESET}"
elif [ "$ROOT_LOGIN_COLOR" = "green" ]; then
    echo -e "Root SSH Login: ${GREEN}${BOLD}$ROOT_LOGIN_STATUS ✅${RESET}"
else
    echo -e "Root SSH Login: ${YELLOW}${BOLD}$ROOT_LOGIN_STATUS ⚠️${RESET}"
fi


SUDO_USERS=$(grep -E 'sudo|wheel|admin' /etc/group 2>/dev/null | cut -d: -f4 | tr '\n' ' ')

if [ -z "$SUDO_USERS" ]; then
    SUDO_USERS="No sudo/admin group users found"
fi

echo "Sudo/Admin Users : $SUDO_USERS"
echo ""

DOCKER_STATUS="NOT INSTALLED"
DOCKER_COLOR="yellow"

DOCKER_CONTAINERS="0"
STOPPED_CONTAINERS="0"

PRIVILEGED_CONTAINERS="0"
ROOT_CONTAINERS="0"
EXPOSED_PORTS="0"

DOCKER_DETAILS="No Docker findings."

if command -v docker >/dev/null 2>&1; then

    if docker info >/dev/null 2>&1; then

        DOCKER_STATUS="RUNNING"
        DOCKER_COLOR="green"

        DOCKER_CONTAINERS=$(docker ps -q | wc -l | tr -d ' ')
        STOPPED_CONTAINERS=$(docker ps -aq -f status=exited | wc -l | tr -d ' ')

        PRIVILEGED_DATA=$(docker ps -q | while read cid
        do
            docker inspect "$cid" \
            --format '{{.Name}} {{.HostConfig.Privileged}}'
        done 2>/dev/null | grep true)

        if [ -n "$PRIVILEGED_DATA" ]; then
            PRIVILEGED_CONTAINERS=$(echo "$PRIVILEGED_DATA" | wc -l | tr -d ' ')
            RISK_SCORE=$((RISK_SCORE + 25))
        fi

        ROOT_DATA=$(docker ps -q | while read cid
        do
            docker exec "$cid" id -u 2>/dev/null
        done | grep "^0$")

        if [ -n "$ROOT_DATA" ]; then
            ROOT_CONTAINERS=$(echo "$ROOT_DATA" | wc -l | tr -d ' ')
            RISK_SCORE=$((RISK_SCORE + 15))
        fi

        EXPOSED_PORTS=$(docker ps \
        --format "{{.Ports}}" \
        | grep -oE "[0-9]+->" \
        | wc -l \
        | tr -d ' ')

        if [ "$EXPOSED_PORTS" -gt 5 ]; then
            RISK_SCORE=$((RISK_SCORE + 10))
        fi

        DOCKER_DETAILS=""

        if [ "$PRIVILEGED_CONTAINERS" -gt 0 ]; then
            DOCKER_DETAILS="${DOCKER_DETAILS}CRITICAL: Privileged containers detected.<br>"
        fi

        if [ "$ROOT_CONTAINERS" -gt 0 ]; then
            DOCKER_DETAILS="${DOCKER_DETAILS}HIGH: Containers running as root.<br>"
        fi

        if [ "$EXPOSED_PORTS" -gt 5 ]; then
            DOCKER_DETAILS="${DOCKER_DETAILS}WARNING: Large number of exposed ports.<br>"
        fi

        if [ -z "$DOCKER_DETAILS" ]; then
            DOCKER_DETAILS="No Docker security findings."
        fi

    else
        DOCKER_STATUS="INSTALLED BUT NOT RUNNING"
        DOCKER_COLOR="yellow"
        RISK_SCORE=$((RISK_SCORE + 5))
    fi

fi

echo -e "${BLUE}${BOLD}Docker Status${RESET}"
echo "-------------------------------------------------"

if [ "$DOCKER_STATUS" = "RUNNING" ]; then
    echo -e "Docker        : ${GREEN}${BOLD}$DOCKER_STATUS ✅${RESET}"
else
    echo -e "Docker        : ${YELLOW}${BOLD}$DOCKER_STATUS ⚠️${RESET}"
fi

echo "Running Containers   : $DOCKER_CONTAINERS"
echo "Stopped Containers   : $STOPPED_CONTAINERS"
echo "Privileged Containers: $PRIVILEGED_CONTAINERS"
echo "Root Containers      : $ROOT_CONTAINERS"
echo "Published Ports      : $EXPOSED_PORTS"
echo ""


AWS_STATUS="NOT CONFIGURED"
AWS_COLOR="yellow"
AWS_ACCOUNT="N/A"

EC2_RUNNING="0"
EC2_DETAILS="No running EC2 instances detected."

RDS_RUNNING="0"
RDS_DETAILS="No RDS instances detected."

ELASTIC_IPS="0"
ELASTIC_IP_DETAILS="No Elastic IPs detected."

NAT_GATEWAYS="0"
NAT_GATEWAY_DETAILS="No NAT Gateways detected."

if command -v aws >/dev/null 2>&1; then
    AWS_IDENTITY=$(aws sts get-caller-identity --output text 2>/dev/null)

    if [ -n "$AWS_IDENTITY" ]; then
        AWS_STATUS="CONNECTED"
        AWS_COLOR="green"
        AWS_ACCOUNT=$(echo "$AWS_IDENTITY" | awk '{print $1}')

        EC2_DATA=$(aws ec2 describe-instances \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].[InstanceId,InstanceType,LaunchTime]" \
            --output text 2>/dev/null)

        if [ -n "$EC2_DATA" ]; then
            EC2_RUNNING=$(echo "$EC2_DATA" | wc -l | tr -d ' ')
            EC2_DETAILS=$(echo "$EC2_DATA" | sed 's/$/<br>/')
            RISK_SCORE=$((RISK_SCORE + 15))
        fi

        RDS_DATA=$(aws rds describe-db-instances \
            --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,DBInstanceStatus]" \
            --output text 2>/dev/null)

        if [ -n "$RDS_DATA" ]; then
            RDS_RUNNING=$(echo "$RDS_DATA" | wc -l | tr -d ' ')
            RDS_DETAILS=$(echo "$RDS_DATA" | sed 's/$/<br>/')
            RISK_SCORE=$((RISK_SCORE + 15))
        fi

        ELASTIC_IP_DATA=$(aws ec2 describe-addresses \
            --query "Addresses[*].[PublicIp,AllocationId,AssociationId]" \
            --output text 2>/dev/null)

        if [ -n "$ELASTIC_IP_DATA" ]; then
            ELASTIC_IPS=$(echo "$ELASTIC_IP_DATA" | wc -l | tr -d ' ')
            ELASTIC_IP_DETAILS=$(echo "$ELASTIC_IP_DATA" | sed 's/$/<br>/')
            RISK_SCORE=$((RISK_SCORE + 10))
        fi

        NAT_DATA=$(aws ec2 describe-nat-gateways \
            --filter "Name=state,Values=available,pending" \
            --query "NatGateways[*].[NatGatewayId,State,CreateTime]" \
            --output text 2>/dev/null)

        if [ -n "$NAT_DATA" ]; then
            NAT_GATEWAYS=$(echo "$NAT_DATA" | wc -l | tr -d ' ')
            NAT_GATEWAY_DETAILS=$(echo "$NAT_DATA" | sed 's/$/<br>/')
            RISK_SCORE=$((RISK_SCORE + 25))
        fi
    fi
fi
echo -e "${BLUE}${BOLD}AWS Cloud Status${RESET}"
echo "-------------------------------------------------"
if [ "$AWS_STATUS" = "CONNECTED" ]; then
    echo -e "AWS CLI       : ${GREEN}${BOLD}$AWS_STATUS ✅${RESET}"
else
    echo -e "AWS CLI       : ${YELLOW}${BOLD}$AWS_STATUS ⚠️${RESET}"
fi
echo "Account       : $AWS_ACCOUNT"
echo "EC2 Running   : $EC2_RUNNING"
echo "RDS Running   : $RDS_RUNNING"
echo "Elastic IPs   : $ELASTIC_IPS"
echo "NAT Gateways  : $NAT_GATEWAYS"
echo ""

if [ "$RISK_SCORE" -lt 30 ]; then
    OVERALL_STATUS="LOW RISK"
    OVERALL_COLOR="green"
elif [ "$RISK_SCORE" -lt 60 ]; then
    OVERALL_STATUS="MEDIUM RISK"
    OVERALL_COLOR="yellow"
else
    OVERALL_STATUS="HIGH RISK"
    OVERALL_COLOR="red"
fi

WORLD_WRITABLE=$(find /tmp /var/tmp -type f -perm -0002 2>/dev/null | wc -l | tr -d ' ')

if [ "$WORLD_WRITABLE" -gt 10 ]; then
    WORLD_WRITABLE_STATUS="CRITICAL"
    WORLD_WRITABLE_COLOR="red"
    RISK_SCORE=$((RISK_SCORE + 20))
elif [ "$WORLD_WRITABLE" -gt 3 ]; then
    WORLD_WRITABLE_STATUS="WARNING"
    WORLD_WRITABLE_COLOR="yellow"
    RISK_SCORE=$((RISK_SCORE + 10))
else
    WORLD_WRITABLE_STATUS="OK"
    WORLD_WRITABLE_COLOR="green"
fi

PASSWORD_POLICY="UNKNOWN"
PASSWORD_POLICY_COLOR="yellow"

if [ -f /etc/login.defs ]; then

    PASS_MAX=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')

    if [ -n "$PASS_MAX" ] && [ "$PASS_MAX" -le 90 ]; then
        PASSWORD_POLICY="GOOD"
        PASSWORD_POLICY_COLOR="green"
    else
        PASSWORD_POLICY="WEAK"
        PASSWORD_POLICY_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 15))
    fi
fi

INACTIVE_USERS=$(awk -F: '$7 ~ /(nologin|false)/ {count++} END {print count+0}' /etc/passwd)

if [ "$INACTIVE_USERS" -gt 10 ]; then
    RISK_SCORE=$((RISK_SCORE + 5))
fi

SSH_PASSWORD_AUTH="UNKNOWN"
SSH_PASSWORD_COLOR="yellow"

if [ -f /etc/ssh/sshd_config ]; then

    if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config; then
        SSH_PASSWORD_AUTH="ENABLED"
        SSH_PASSWORD_COLOR="red"
        RISK_SCORE=$((RISK_SCORE + 20))
    else
        SSH_PASSWORD_AUTH="DISABLED"
        SSH_PASSWORD_COLOR="green"
    fi
fi




echo -e "${BLUE}${BOLD}Overall Result${RESET}"
echo "-------------------------------------------------"

if [ "$OVERALL_COLOR" = "green" ]; then
    echo -e "Risk Score    : ${GREEN}${BOLD}$RISK_SCORE/100${RESET}"
    echo -e "Status        : ${GREEN}${BOLD}$OVERALL_STATUS${RESET}"
elif [ "$OVERALL_COLOR" = "yellow" ]; then
    echo -e "Risk Score    : ${YELLOW}${BOLD}$RISK_SCORE/100${RESET}"
    echo -e "Status        : ${YELLOW}${BOLD}$OVERALL_STATUS${RESET}"
else
    echo -e "Risk Score    : ${RED}${BOLD}${UNDERLINE}$RISK_SCORE/100${RESET}"
    echo -e "Status        : ${RED}${BOLD}${UNDERLINE}$OVERALL_STATUS${RESET}"
fi

echo ""

cp "$TEMPLATE_FILE" "$HTML_REPORT"



sed -i.bak \
    -e "s|{{HOSTNAME}}|$HOSTNAME_VALUE|g" \
    -e "s|{{USER}}|$CURRENT_USER|g" \
    -e "s|{{SCAN_DATE}}|$SCAN_DATE|g" \
    -e "s|{{RISK_SCORE}}|$RISK_SCORE|g" \
    -e "s|{{OVERALL_STATUS}}|$OVERALL_STATUS|g" \
    -e "s|{{OVERALL_COLOR}}|$OVERALL_COLOR|g" \
    -e "s|{{DISK_USAGE}}|$DISK_USAGE%|g" \
    -e "s|{{DISK_STATUS}}|$DISK_STATUS|g" \
    -e "s|{{DISK_COLOR}}|$DISK_COLOR|g" \
    -e "s|{{MEMORY_USAGE}}|$MEMORY_USAGE%|g" \
    -e "s|{{MEMORY_STATUS}}|$MEMORY_STATUS|g" \
    -e "s|{{MEMORY_COLOR}}|$MEMORY_COLOR|g" \
    -e "s|{{OPEN_PORTS}}|$OPEN_PORTS|g" \
    -e "s|{{PORT_STATUS}}|$PORT_STATUS|g" \
    -e "s|{{PORT_COLOR}}|$PORT_COLOR|g" \
    -e "s|{{DOCKER_STATUS}}|$DOCKER_STATUS|g" \
    -e "s|{{DOCKER_COLOR}}|$DOCKER_COLOR|g" \
    -e "s|{{DOCKER_CONTAINERS}}|$DOCKER_CONTAINERS|g" \
    -e "s|{{STOPPED_CONTAINERS}}|$STOPPED_CONTAINERS|g" \
    -e "s|{{PRIVILEGED_CONTAINERS}}|$PRIVILEGED_CONTAINERS|g" \
    -e "s|{{ROOT_CONTAINERS}}|$ROOT_CONTAINERS|g" \
    -e "s|{{EXPOSED_PORTS}}|$EXPOSED_PORTS|g" \
    -e "s|{{DOCKER_DETAILS}}|$DOCKER_DETAILS|g" \
    -e "s|{{AWS_STATUS}}|$AWS_STATUS|g" \
    -e "s|{{AWS_COLOR}}|$AWS_COLOR|g" \
    -e "s|{{AWS_ACCOUNT}}|$AWS_ACCOUNT|g" \
    -e "s|{{EC2_RUNNING}}|$EC2_RUNNING|g" \
    -e "s|{{EC2_DETAILS}}|$EC2_DETAILS|g" \
    -e "s|{{RDS_RUNNING}}|$RDS_RUNNING|g" \
    -e "s|{{RDS_DETAILS}}|$RDS_DETAILS|g" \
    -e "s|{{ELASTIC_IPS}}|$ELASTIC_IPS|g" \
    -e "s|{{ELASTIC_IP_DETAILS}}|$ELASTIC_IP_DETAILS|g" \
    -e "s|{{NAT_GATEWAYS}}|$NAT_GATEWAYS|g" \
    -e "s|{{NAT_GATEWAY_DETAILS}}|$NAT_GATEWAY_DETAILS|g" \
    -e "s|{{FAILED_LOGINS}}|$FAILED_LOGINS|g" \
    -e "s|{{FAILED_LOGIN_STATUS}}|$FAILED_LOGIN_STATUS|g" \
    -e "s|{{FAILED_LOGIN_COLOR}}|$FAILED_LOGIN_COLOR|g" \
    -e "s|{{WORLD_WRITABLE}}|$WORLD_WRITABLE|g" \
    -e "s|{{WORLD_WRITABLE_STATUS}}|$WORLD_WRITABLE_STATUS|g" \
    -e "s|{{WORLD_WRITABLE_COLOR}}|$WORLD_WRITABLE_COLOR|g" \
    -e "s|{{PASSWORD_POLICY}}|$PASSWORD_POLICY|g" \
    -e "s|{{PASSWORD_POLICY_COLOR}}|$PASSWORD_POLICY_COLOR|g" \
    -e "s|{{INACTIVE_USERS}}|$INACTIVE_USERS|g" \
    -e "s|{{SSH_PASSWORD_AUTH}}|$SSH_PASSWORD_AUTH|g" \
    -e "s|{{SSH_PASSWORD_COLOR}}|$SSH_PASSWORD_COLOR|g" \
    -e "s|{{FIREWALL_STATUS}}|$FIREWALL_STATUS|g" \
    -e "s|{{FIREWALL_COLOR}}|$FIREWALL_COLOR|g" \
    -e "s|{{SSH_STATUS}}|$SSH_STATUS|g" \
    -e "s|{{SSH_COLOR}}|$SSH_COLOR|g" \
    -e "s|{{ROOT_LOGIN_STATUS}}|$ROOT_LOGIN_STATUS|g" \
    -e "s|{{ROOT_LOGIN_COLOR}}|$ROOT_LOGIN_COLOR|g" \
    -e "s|{{SUDO_USERS}}|$SUDO_USERS|g" \
    "$HTML_REPORT"

rm -f "$HTML_REPORT.bak"

echo -e "${GREEN}${BOLD}HTML report generated:${RESET} $HTML_REPORT"
