#!/usr/bin/env bash

./setup_extensions.sh

pkexec systemctl enable warp-svc && systemctl start warp-svc
sleep 1
warp-cli registration new
