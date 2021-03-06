## Install StorageOS cli

StorageOS cli can be installed using script available. 

``./install-cli.sh``{{execute}}

You can verify the installation by checking the verson of the cli ``storageos version``{{execute}}

## Logging in to the Cluster

To login to the OpenShift cluster from the _Terminal_ run:

``oc login --insecure-skip-tls-verify=true -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

In order that you can still run commands from the command line as a cluster
admin, the ``sudoer`` role has been enabled for the ``developer`` account.
To execute a command as a cluster admin use the ``--as system:admin`` option
to the command.

## Create the 'demo' project

``oc new-project demo``{{execute}}

Check out the project.

``oc get projects --as system:admin``{{execute}}

## Prepare StorageOS

You will find the yaml spec files to deploy StorageOS in the directory ~/storageos 

``ls ~/storageos``{{execute}}

``oc --as system:admin create -f ~/storageos/storageclass.yaml``{{execute}}


## Add accounts ands privileges 

We are going to create a serviceaccount and grant the permissions required so StorageOS can operate at full capacity.

``oc create -f ~/storageos/serviceaccount.yaml``{{execute}}

``oc create -f ~/storageos/role.yaml``{{execute}}

``oc create -f ~/storageos/rolebinding.yaml``{{execute}}

### Add scc (security context constraint) to the service account

By default, your openshift installation will trigger pods with the deployer scc, which is ``restricted``. However, StorageOS needs more privileges to interact with the host. 
We will grant the capacity to start pods under privileged scc to the serviceaccount created previously.

``oc --as system:admin adm policy add-scc-to-user privileged system:serviceaccount:demo:storageos``{{execute}}


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

Copy the result hash to the JOIN value env variable in ``~/storageos/daemonset.yaml`` by running:

``sed -i -e "s/JOIN_VALUE/$CLUSTER_ID/" ~/storageos/daemonset.yaml``{{execute}}

Create the daemonset.

``oc --as system:admin create -f ~/storageos/daemonset.yaml``{{execute}}

## Persistent Volume Claims

Wait until StorageOS pod is started and ready.

``oc get pods -lapp=storageos``{{execute}}

Create a persistent volume claim.

``oc create -f ~/storageos/pvc.yaml``{{execute}}

Inspect the claim status.

``oc describe pvc/redis-test``{{execute}}

## Check StorageOS volumes

``storageos -ustorageos -pstorageos -h 127.0.0.1 volume ls``{{execute}}

## Create a pod to test the pvc

``oc create -f ~/storageos/redis.yaml``{{execute}}
