## Prepare host

Required kernel modules will be enabled by running the following `./enable-lio.sh`

``chmod +x enable-lio.sh && ./enable-lio.sh``{{execute}}

## Install StorageOS

(Until openshift version 3.9 feature gates such as mount propagation are not supported. Because of that the installation of StorageOS is done by container installation rather than DaemonSet)

``
docker run -d --name storageos \
           -e HOSTNAME \
           -e ADVERTISE_IP=[[HOST_IP]] \
           -e JOIN=[[HOST_IP]] \
           --pid=host \
           --network=host \
           --privileged \
           --cap-add SYS_ADMIN \
           --device /dev/fuse \
           -v /sys:/sys \
           -v /var/lib/storageos:/var/lib/storageos:rshared \
           -v /run/docker/plugins:/run/docker/plugins \
           storageos/node:1.0.0-rc2 server
``{{execute}}


## Create StorageClass

First, it is required to create a secret that sets the api endpoint of StorageOS

`APIADDRESS=$(echo -n "tcp://127.0.0.1:5705" | base64); sed -i "s/REPLACE/$APIADDRESS/g" secret.yaml`{{execute}}

`oc --as system:admin -n default create -f secret.yaml`{{execute}}

Create `fast` StorageClass:

`oc --as system:admin create -f storageclass.yaml`{{execute}}


## Check StorageOS status

Using storageos cli: ``storageos --host 127.0.0.1 -u $STORAGEOS_USER -p $STORAGEOS_PASSWORD cluster health``{{execute}}

It is possible to check the health rest api endpoint by: ``curl 127.0.0.1:5706/health``{{execute}}

## Create Persistent Volume Claim

`oc create -f pvc.yaml`{{execute}}

List volumes:
`oc get pv,pvc`{{execute}}

List volumes with StorageOS cli:
`storageos --host 127.0.0.1 -u $STORAGEOS_USER -p $STORAGEOS_PASSWORD volume ls`{{execute}}

## Test pods

In this section, we create a pod that mounts a PVC and it writes the string `Testing StorageOS with Openshift` in it. Once the pod is finished, we start a different pod that mounts
the same volume and prints the data to STDOUT.

Create a pod that writes to the pvc. 
`oc create -f pod-write.yaml`{{execute}}

`oc get pods`{{execute}}

The pod finishes as soon as the file has been written. Lets check the data in the volume by attaching it to a new pod that will print written data to STDOUT.


(Wait until the write pod finishes `until [ "$(oc get pods | grep write | grep  -c Completed)" -gt 0  ]; do sleep 1; done`{{execute}})

`oc create -f pod-read.yaml`{{execute}}

Check the output of the read pod coming from the persisted volume.

`oc logs read`{{execute}}

