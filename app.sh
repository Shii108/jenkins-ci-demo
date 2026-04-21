#!/bin/bash

echo "App Version: ${APP_VERSION:-1.0.0}"
echo "Build Timestamp: ${BUILD_TS:-$(date)}"
echo "Hostname: $(hostname)"
echo "Date: $(date)"

echo "System Info:"
uname -a
whoami
uptime
