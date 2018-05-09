## Install StorageOS cli

StorageOS cli can be installed using script available. 

``./install-cli.sh``{{execute}}

You can verify the installation by checking the version of the cli ``storageos version``{{execute}}

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
