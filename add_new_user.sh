#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

source /root/admin-openrc

name_project=$1

id_project=`openstack project list | grep vdc_urimukhin_test | awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`

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
id_network=`openstack network list --project $id_project --name network_private | grep -v '+\|ID'| awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`
openstack subnet create --project $id_project --dhcp --subnet-range 192.168.1.0/24 --dns-nameserver 8.8.8.8 --network $id_network subnet_private

#add network to a router
id_subnet=`openstack subnet list --project $id_project --name subnet_private | grep -v '+\|ID'| awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`
openstack router add subnet $id_router $id_subnet

#edit security_group
id_security=` openstack security group list --project $id_project | grep default | grep -v '+\|ID'| awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d'`
openstack security group rule create --protocol icmp --ingress --project $id_project $id_security
openstack security group rule create --protocol icmp --egress --project $id_project $id_security
openstack security group rule create --protocol TCP --ingress --project $id_project $id_security --dst-port 22
openstack security group rule create --protocol TCP --ingress --project $id_project $id_security --dst-port 443
openstack security group rule create --protocol TCP --ingress --project $id_project $id_security --dst-port 80
openstack security group rule create --protocol TCP --ingress --project $id_project $id_security --dst-port 53
openstack security group rule create --protocol UDP --ingress --project $id_project $id_security --dst-port 53
openstack security group rule create --protocol TCP --ingress --project $id_project $id_security --dst-port 3389
