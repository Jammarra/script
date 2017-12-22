#!/usr/bin/python
import json
import sys
import re
from urllib2 import urlopen
from xml.dom import minidom
#parsed_json = json.load(sys.stdin)
#level_json = json.dumps(parsed_json['level'])
#message_json = json.dumps(parsed_json['message'])
url = "https://my.url.ru:443/billmgr?authinfo=user:password&out=xml&func=clientticket.edit&sok=ok&client_department=452146&name=%s&message=%s" % (message_json, message_json) 
url = url.replace(' ','_')
if level_json  == '"CRITICAL"':
	res = urlopen(str(url)) 
