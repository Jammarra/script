#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

source /root/admin-openrc

id_project=$1

#add group
openstack role add --group s_g_admin --project $id_project admin
openstack role add --group s_g_viewers --project $id_project s_r_rouser
openstack role add --group s_g_poweruser --project $id_project user

#create router
openstack router create --project $id_project router --ha --availability-zone nova
id_router=`openstack router list --project $id_project --name router | grep -v '+\|ID'| awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`
openstack router set $id_router --external-gateway cc75cb3f-0922-4f23-b077-099d9cd0ec1a

#create network
openstack network create --project $id_project --no-share network_private
openstack subnet create --project $id_project --dhcp --subnet-range 192.168.1.0/24 --dns-nameserver 8.8.8.8 --network network_private subnet_private

#add network to a router
id_network=`openstack subnet list --project $id_project --name subnet_private | grep -v '+\|ID'| awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`
openstack router add subnet $id_router $id_network
