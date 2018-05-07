## Logging in to the Cluster

To login to the OpenShift cluster from the _Terminal_ run:

``oc login``{{execute}}

Accept the insecure connection. 

Use the following credentials:

* **Username:** ``developer``{{execute}}
* **Password:** ``developer``{{execute}}

Use the same credentials to log into the web console.

In order that you can still run commands from the command line as a cluster
admin, the ``sudoer`` role has been enabled for the ``developer`` account.
To execute a command as a cluster admin use the ``--as system:admin`` option
to the command. For example:

``oc get projects --as system:admin``{{execute}}

## Create the 'demo' project

``oc new-project demo``{{execute}}

## Create a service account for StorageOS

``oc create serviceaccount storageos -n demo``{{execute}}

## Add privileged scc (security context constraint) to the service account

``oc adm policy add-scc-to-user privileged system:serviceaccount:demo:storageos --as system:admin``{{execute}}

## Persistent Volume Claims

Persistent volumes have been pre-created in the playground environment.
These will be used if you make persistent volume claims for an application.
The volume sizes are defined as 100Gi each, however you are limited by how
much disk space the host running the OpenShift environment has, which is
much less.

To view the list of available persistent volumes you can run:

``oc get pv --as system:admin``{{execute}}

