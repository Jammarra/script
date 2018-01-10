#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

source /root/admin-openrc

id_project=$(openstack project list | grep -v '+\|ID\|a2236b5f83d34f64b9fbf8579cdfd359\|12b24cafc1af4ddcae75e8ef350324ad\|0d9f2bc92f1648f7a067170aa0a17a83\|451c1fe88fc04f38b8c0eefe05b48fcc\|644c92bf7dc1406994b73b2e41f4d623\|4c817760e0744cdda439f4694ded0ca2\|68e27948c1274a3b863deda22af3a818\|089b1817ff19487a829e3203866d03e3\|e69e6f92a2e345239f47062d60d72362\|3a677c2d74fe4d0588add11015266e2a\|82cff387e99e464c9cf232a0285b10e7\|e5fc79f83f65498b9d2006f3d9f77637\|102d2ecf97d24a15a59882d20bf1aa47\|721b721a9d004f13a6a99b2a06d4c655\|99eb7e2a65bd40a5a617179f59a96d66\|896bfea9169f44bb85798982d8e24d72\|c976764b49d64605be4fd52279d3d08a\|81c0a8189a024b51a128079bba111d2d\|7d098a42a0c941ad8d0001b832d6b13f\|041ca9b233fa4c80978e16d02c01e5e4\|ccba5fcd33944266aed7adb3c9efe757\|af8b461a476448889551dbd074e25754\|40eed7e8841a4d8e9d26f61a7e973979\|ee2db7e6c8824dc8a3041a722e03e365\|74547ef8057448f583b7e7c13c289e0f\|43a26eba60154376bd9b3fd4d0bda51b\|26818ac591c74d019f101c0c5acb180f\|001d3d78af894a63afe1598fde09c416\|8c4983dcb1fc41d1a18bc6a92c3e8be8\|d0a35a9035b44d3c98570e73c8945bb0\|7e030eab3549449bba2b12dcecf9477a\|6a9fc9bcee794c7983d18655db966f30' | awk -F '|' '{print $2}' | sed 's/^ //; s/ $//; /^$/d')

for id_project in ${id_project}; do
	openstack role add --group s_g_admin --project $id_project admin
	openstack role add --group s_g_viewers --project $id_project s_r_rouser
	openstack role add --group s_g_poweruser --project $id_project user
done
