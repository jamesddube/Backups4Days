#!/usr/bin/python3
'''
Get the list of a directory's contents in an email.
Useful to verify if a backup completed successfully.
For example: if you see new files in the email, you know that
the backup was completed. Files listed in reverse alphabetical order
to accomodate filenames that represent a timestamp.

*Uses Gmail to send the email message. You'll need valid Gmail credentials.

By Max Thauer
'''
import smtplib, os, sys 

gmailUsername = ("USERNAME@gmail.com")
gmailPassword = ("PASSWORD")
senderName = ("SENDER_NAME_HERE")
receiverName =("RECEIVER_NAME_HERE")
sender = ("USERNAME@gmail.com")
receivers = ['RECEIVER_ADDRESS@domain.tld'] #List of email addresses, separated by commas.
mimeVersion = ("1.0")
contentType = ("text/plain")
subject = ("SUBJECT_GOES_HERE")

path = ("/path/to/your/directory/")
dirs = os.listdir(path)

fileList = []
recipients = ''.join(receivers)

for file in dirs:
    fileList.append("{}\n".format(file))

fileList.reverse()
body = "".join(fileList)

message = "From: "+senderName+" <"+sender+">\nTo: "+receiverName+" <"+recipients+">\nMime version: "+mimeVersion+"\nContent-type: "+contentType+"\nSubject: "+subject+"\n\n{}".format(body)

try: 
    smtpObj = smtplib.SMTP(host='smtp.gmail.com', port=587)
    smtpObj.ehlo()
    smtpObj.starttls()
    smtpObj.ehlo()
    smtpObj.login(gmailUsername,gmailPassword)
    smtpObj.sendmail(sender, receivers, message)
    smtpObj.quit()
    print ("Successfully sent email")
except smtplib.SMTPException:
    print ("Error: unable to send email")
