#!/bin/bash

curl -kLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0-rc1/storageos_linux_amd64

[ -f storageos ] && chmod +x storageos
