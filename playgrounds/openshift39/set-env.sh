~/.launch.sh
curl -kLsSo storageos https://github.com/storageos/go-cli/releases/download/1.0.0-rc1/storageos_linux_amd64 
chmod +x storageos && mv storageos /usr/local/bin
[ ! -d /var/lib/storageos ] && (mkdir -p /var/lib/storageos && chmod 0777 /var/lib/storageos)
echo "Finished launching"

