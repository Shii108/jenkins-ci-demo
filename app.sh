#!/bin/bash

echo "App Version: 2.0.0"
echo "Build Timestamp: ${BUILD_TS:-$(date)}"
echo "Hostname: $(hostname)"
echo "Date: $(date)"

echo "System Info:"
echo "Kernel: $(uname -r)"
uname -a
whoami
uptime
