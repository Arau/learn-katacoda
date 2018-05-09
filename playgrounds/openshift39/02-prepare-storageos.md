
You will find the yaml spec files to deploy StorageOS in the directory ~/storageos 

``ls ~/storageos``{{execute}}

``oc --as system:admin create -f ~/storageos/storageclass.yaml``{{execute}}

## Add accounts and privileges 

We are going to create a service account and grant the permissions required so StorageOS can operate at full capacity.

``oc create -f ~/storageos/serviceaccount.yaml``{{execute}}

StorageOS needs to manage secrets to be able to autodiscover nodes.

``oc create -f ~/storageos/role.yaml``{{execute}}

Once we have a service account and a role, we need to bind them toghether.

``oc create -f ~/storageos/rolebinding.yaml``{{execute}}

## Add scc (security context constraint) to the service account

By default, your openshift installation will trigger pods with the deployer scc, which is ``restricted``. However, StorageOS needs more privileges to interact with the host. 
We will grant the capacity to start pods under privileged scc to the serviceaccount created previously.

``oc --as system:admin adm policy add-scc-to-user privileged system:serviceaccount:demo:storageos``{{execute}}
