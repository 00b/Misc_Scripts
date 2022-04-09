#!/usr/bin/python3
from lxml import html
import smtplib
import requests

#Gets and sends email with jury duty information for a specific jury group number from Superior Court of California, County of Sacramento. 
#If site changes script will likely break. 
#Script worked on April 8th 2022. 

#
#Setup/Config
#
#Jury page with instructions:
Jury_URL = 'https://www.saccourt.ca.gov/jury/reporting.aspx'
#Jury duty group number
Jury_Group = '###'

#email address details. 
email_to_address = 'user@domain.tld'
from_address = 'username@domain.tld'
smtp_password = 'hunter2'
smtp_host = 'smtp.gmail.com'
smtp_port = 587


def sendemail(messagesub,messagebody):
    conn = smtplib.SMTP(smtp_host, smtp_port) # smtp address and port
    conn.ehlo() # call this to start the connection
    conn.starttls() # starts tls encryption. When we send our password it will be encrypted.
    conn.login(from_address, smtp_password)
    conn.sendmail(from_address, email_to_address, 'Subject:' + messagesub + '\n\n'+messagebody)
    conn.quit()


ret_data = requests.get(Jury_URL)
tree = html.fromstring(ret_data.content)
Table = tree.xpath('//tr')
found = False
for row in Table: 
    groups=row.xpath('./td[1]/text()')
    if len(groups) > 0:
        if Jury_Group in groups[0]:
            instructions = row.xpath('./td[2]/text()')
            message = (f'Jury group {Jury_Group} instructions: {instructions[0]} \n {Jury_URL}')
            #print(f'Jury Group {Jury_Group} instuctions: {instructions[0]}')
            found = True
if not found:
    message = (f'Unable to find jury group {Jury_Group} at {Jury_URL}')
    #print (f'Unable to find Jury Group {Jury_Group}')

#print(message)
sendemail('Jury Duty Status',message)
