# vmware-linkedclone
allows you to create a linked clone in VMWare ESX 6 (and probably before)

#Overview:
Stores a base image in /vmfs/volumes/vm/BASE
Each BASE image has 1 snapshot (makes cloning possible)
The clones essentially reference the BASE image as their 'parent snapshot'

WARNING - DO NOT CONSOLIDATE - vmware will tell you a VM needs consolidating...don't do it.

#Install:

if you do not have a datastore called 'vm' then please create a symlink
ln -s <real location> /vmfs/volumes/vm
mkdir /vmfs/volumes/vm/BASE

copy all scripts into that folder

#Use:
1. Build your new VM and get it how you want it.
2. Create 1 SNAPSHOT (I typically call this "BASE")
3. Prepare the image for cloning
     Prepare an image that is not in the BASE folder:
       ./prepare_base.sh /path/to/source/image
    
     Prepare an image that is already in the BASE folder:
       ./prepare_base_nomove.sh /path/to/source/image
4. Create and Register a Linked Clone (must already be prepared..above)
     ./mk_linked_clone.sh <src vm name> <target directory> <new vm name>

     e.g. ./mk_linked_clone.sh Win2012BASEIMAGE /vmfs/volumes/mydatastore/demo01 Win2012_001
           will create and register a new VM(Win2112_001)
5. Remove the original VM from your inventory

