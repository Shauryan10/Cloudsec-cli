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
PORT_STATUS=$(get_status "$OPEN_PORTS" 10 20)

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

DOCKER_STATUS="NOT INSTALLED"
DOCKER_COLOR="yellow"
DOCKER_CONTAINERS="0"

if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        DOCKER_STATUS="RUNNING"
        DOCKER_COLOR="green"
        DOCKER_CONTAINERS=$(docker ps -q | wc -l | tr -d ' ')
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
echo "Containers    : $DOCKER_CONTAINERS"
echo ""

AWS_STATUS="NOT CONFIGURED"
AWS_COLOR="yellow"
AWS_ACCOUNT="N/A"
EC2_RUNNING="0"
EC2_DETAILS="No running EC2 instances detected."

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

STYLE_CONTENT=$(cat "$CSS_FILE")

sed -i.bak \
    -e "s|{{STYLE}}|$STYLE_CONTENT|g" \
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
    -e "s|{{AWS_STATUS}}|$AWS_STATUS|g" \
    -e "s|{{AWS_COLOR}}|$AWS_COLOR|g" \
    -e "s|{{AWS_ACCOUNT}}|$AWS_ACCOUNT|g" \
    -e "s|{{EC2_RUNNING}}|$EC2_RUNNING|g" \
    -e "s|{{EC2_DETAILS}}|$EC2_DETAILS|g" \
    "$HTML_REPORT"

rm -f "$HTML_REPORT.bak"

echo -e "${GREEN}${BOLD}HTML report generated:${RESET} $HTML_REPORT"
