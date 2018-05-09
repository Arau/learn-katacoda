# Deploy StorageOS cluster

## Create a persistent volume claim.

We are creating a persistent volume claim using the storageclass ``fast``, we created previously.

``oc create -f ~/storageos/pvc.yaml``{{execute}}

Inspect the claim status.

``oc describe pvc/redis-test``{{execute}}

## Check StorageOS volumes

``storageos -ustorageos -pstorageos -h 127.0.0.1 volume ls``{{execute}}

``storageos -ustorageos -pstorageos -h 127.0.0.1 node ls``{{execute}}

## Create a pod to test the pvc

``oc create -f ~/storageos/redis.yaml``{{execute}}
