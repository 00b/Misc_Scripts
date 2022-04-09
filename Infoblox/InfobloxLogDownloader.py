#!/usr/bin/python3
#Download syslogs from members of infoblox grid using the infoblox API. 
#code provided as is. 

import json
import requests 
import getpass
import argparse
import datetime

#un-comment line below to suppress SSL and other warnings... 
#urllib3.disable_warnings()

#preset some items to make it easier to run. 
username = "username"
password = "hunter2"
dlpath = "/path/to/savefiles/" #path to store the downloaded files. trailing / required.  

infoblox_host = "infobloxhost.domain.tld" #or IP

#argument parsing/setup. 
parser = argparse.ArgumentParser()
parser.add_argument("--username", "-u", help="username to use")
parser.add_argument("--password", "-p", help="password to use")
parser.add_argument("--dlpath", "-d", help="download path")

args = parser.parse_args()

#if arguments specified use them. 
if args.username:
    username=args.username
if args.password:
    password=args.password
if args.dlpath:
    dlpath=args.dlpath


#prompt for username if none entered:
if len(username) == 0:
    username=input("username: ")
else:
    print ("using username: "+username)

#prompt for password if none entered: 
if len(password) == 0:
    password = getpass.getpass()
else:
    print ('using stored password')

#build the base/root url. 
baseurl = "https://"
baseurl = baseurl + infoblox_host

def getmembers():
    #print('getting members')
    members = []
    requestpath = "/wapi/v2.7.1/member?_return_as_object=1"
    memberreq_url = baseurl + requestpath
    memberreq_resp = requests.get(memberreq_url, verify=False, auth=(username,password))
    memberdata = json.loads(memberreq_resp.content)
    for i in memberdata["result"]:
        members.append(i["host_name"])
    return (members)

def downloadlogs(dlurl,filenameprefix=None):
    #print('downloading')
    downloadheaders={'Content-type':'applicatin/force-download'}
    local_filename = dlpath + filenameprefix
    local_filename = local_filename + dlurl.split('/')[-1]
    with requests.get(dlurl, verify=False, stream=True, auth=(username, password), headers=downloadheaders
) as r:
            r.raise_for_status()
            with open(local_filename , 'wb') as f:
                for chunk in r.iter_content(chunk_size=1024):
                    if chunk:
                       f.write(chunk)

members = getmembers()

for member in members:
    #download logs from each. 
    requestpath = "/wapi/v2.7.1/fileop?_function=get_log_files"
    requesturl = baseurl + requestpath
    logparams='{"include_rotated":true,"log_type":"SYSLOG","member":"' + member + '","node_type":"ACTIVE"}
'
    #setup the filename to prepent hostname and datetime to file name. 
    #host.tld-12-31-1999:00:00:01-syslog.tar.gz
    fileprefix = member
    fileprefix = fileprefix +"-"+datetime.datetime.now().strftime("%m-%d-%Y:%H:%M:%S")+"-"
    #create the log request
    response = requests.post(requesturl, verify=False, auth=(username, password), data=logparams)
    data=json.loads(response.content) 
    downloadurl=data['url']
    #print(f"getting logs for {member}") 
    downloadlogs(downloadurl,fileprefix)
    #Cleanup. Remove requetsed log pack from server.
    requestpath='/wapi/v2.7.1/fileop?_function=downloadcomplete'
    cleanupurl = baseurl + requestpath
    #print(cleanupurl)
    cleanupheaders={'Content-Type': 'application/json'}
    cleanuptoken=json.dumps(data['token'])
    cleanupparams='{ "token": ' + cleanuptoken +' }'
    #print(cleanupparams)
    cleanupresponse=requests.post(cleanupurl, verify=False, auth=(username, password), data=cleanupparams,
            headers=cleanupheaders)
    #print(response)
    cleanupdata=json.loads(cleanupresponse.content)
    #print(cleanupdata)
