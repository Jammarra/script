#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

source /root/admin-openrc

images=$(openstack image list --long  --format csv | tail -n+2 | grep active | egrep -v "(iso|raw)" | tr -d '"')

for image in ${images}; do
    IFS=',' read id name format owner share <<< $(echo ${image} | awk -F, '{print $1","$2","$3","$10","$8}')
    rbd export images/${id} /tmp/${id}
    qemu-img convert -f ${format} -O raw /tmp/${id} /tmp/${id}.raw
    openstack image create  --container-format bare --disk-format raw --file /tmp/${id}.raw --${share} --project ${owner} --project-domain default ${name}
#    rm -rf /tmp/${id}
    rm -rf /tmp/${id}.raw
    openstack image delete ${id}
done
