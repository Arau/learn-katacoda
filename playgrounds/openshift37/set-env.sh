~/.launch.sh

mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF > /etc/systemd/system/docker.service.d/clear_mount_propagtion_flags.conf
[Service]
MountFlags=shared
EOF

export STORAGEOS_USER=storageos STORAGEOS_PASSWORD=storageos
oc --as system:admin cluster down
systemctl daemon-reload
systemctl restart docker.service
oc --as system:admin cluster up &> /dev/null
