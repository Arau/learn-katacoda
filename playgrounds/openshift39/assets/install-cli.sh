#!/bin/bash

echo "Installing StorageOS cli"
curl -ksSL https://github.com/storageos/go-cli/releases/download/1.0.0-rc1/storageos_linux_amd64 -o storageoscli

[ -f storageos ] && chmod +x storageoscli && mv storageoscli /usr/local/bin/storageos
