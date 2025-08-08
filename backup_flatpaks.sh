#!/usr/bin/env bash

flatpak list --columns=application --app | tee flatpaks.txt
