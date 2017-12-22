#!/usr/bin/python
import json
import sys
import re
import subprocess
from subprocess import Popen, PIPE
user_list=Popen('echo "select user_id from credential;" | mysql keystone | grep -v "user_id" | sort | uniq', shell=True, stdin=PIPE, stdout=PIPE).stdout.read().split()
A = []
B = []
i = 0  
while i < len(user_list):
	A.append(Popen("openstack ec2 credentials list --user=%s | awk -F '|' '{print $4,$2,$3}' | grep -v ' Access ' | sed 's/^ //; s/ $//; /^$/d'" % user_list[i], shell=True, stdin=PIPE, stdout=PIPE).stdout.read().split())
	i=i+1
for i in range (len(A)):
	for j in range (len(A[i])):
		B.append(A[i][j])


for i in range (0,len(B),3):
	user_access, error =  Popen("radosgw-admin user info --uid='%s$%s' | grep -v 'access_key' | grep %s" % (B[i], B[i], B[i+1]), shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE).communicate()
	if not error:
		if not user_access:
			Popen("radosgw-admin key create --uid='%s$%s' --key-type=s3 --access-key %s --secret-key %s" % (B[i], B[i], B[i+1], B[i+2]), shell=True, stdin=PIPE)
