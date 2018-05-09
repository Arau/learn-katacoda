## Deploy StorageOS api service

``oc create -f ~/storageos/service.yaml``{{execute}}

Add service IP to the storageos-api secret. Adding the dns name would only work in the case that you added a cluster dns, otherwise the cluster won't start as it can't resolve the name.

``CLUSTER_IP=$(oc get svc/storageos -o custom-columns=IP:spec.clusterIP --no-headers=true)``{{execute}}

Verify the ip: ``echo $CLUSTER_IP``{{execute}}

Create the api address string.

``API=$(echo -n "tcp://$CLUSTER_IP:5705" | base64)``{{execute}}

Add the api address to secrets.yaml and create the secret.

``sed -i -e "s/ADDRESS/$API/" ~/storageos/secrets.yaml``{{execute}}

``oc create -f ~/storageos/secrets.yaml``{{execute}}

## Get a cluster id

StorageOS has got different ways to make the members of a cluster know each other. We will use a token so every member of the cluster using the same token will discover automatically its peers, and join the cluster.

``CLUSTER_ID=$(storageos cluster create)``{{execute}}

Verify the id ``echo $CLUSTER_ID``{{execute}}

## Set the JOIN token

Copy the result hash to the JOIN value env variable in ``~/storageos/daemonset.yaml`` by running:

``sed -i -e "s/JOIN_VALUE/$CLUSTER_ID/" ~/storageos/daemonset.yaml``{{execute}}


## Bootstrap StorageOS pod

Create the daemonset.

``oc --as system:admin create -f ~/storageos/daemonset.yaml``{{execute}}

Wait until the pod starts ``oc get daemonset/storageos``{{execute}} or ``oc get pods -lapp=storageos``{{execute}}
