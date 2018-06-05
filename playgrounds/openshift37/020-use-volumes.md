## Create Persistent Volume Claim

`oc create -f pvc.yaml`{{execute}}

List volumes:
`oc get pv,pvc`{{execute}}

List volumes with StorageOS cli:
`storageos --host 127.0.0.1 -u $STORAGEOS_USER -p $STORAGEOS_PASSWORD volume ls`{{execute}}

See the status of the volume with oc cli and verify the volume is successfully allocated. 

`oc describe pvc`{{execute}}

## Test pods

In this section, we create a pod that mounts a PVC and it writes the string `Testing StorageOS with Openshift` in it. Once the pod is finished, we start a different pod that mounts
the same volume and prints the data to STDOUT.

Create a pod that writes to the pvc. 
`oc create -f pod-write.yaml`{{execute}}

`oc get pods`{{execute}}

The pod finishes as soon as the file has been written. Lets check the data in the volume by attaching it to a new pod that will print written data to STDOUT.

Wait until the write pod finishes and delete afterwards.

`
until [ "$(oc get pods | grep write | grep  -c Completed)" -gt 0  ]; do 
    sleep 1; 
done

oc delete po write
`{{execute}})

`oc create -f pod-read.yaml`{{execute}}

Check the output of the read pod coming from the persisted volume.

`oc logs read`{{execute}}

You can see that the string `Testing StorageOS with Openshift` has been persisted between executions. Mind that it doesn't matter if the pod `read` would run
in a different host of the pod `write` as StorageOS takes care of it. The data is accessible from anywhere in your cluster.
