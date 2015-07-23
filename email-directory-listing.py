#Python 2.7.6
# Import smtplib for the actual sending function
import smtplib
import os, sys
# Import the email modules we'll need

path = "/path/to/your/directory"
dirs = os.listdir( path )

for file in dirs:
	mylist = dirs 
	for elem in mylist:
		print "\n".join(mylist)
	
#need to alter the contents of mylist to have new lines. 
# eventually add .reverse() to reverse order of list for newest files first


try:
    sender = 'SENDER-EMAIL@gmail.com'
    receivers = ['username@domain.tld']
    message = """From: Daily Update <SENDER-EMAIL@gmail.com>
To: YOUR NAME <username@domain.tldm>
MIME-Version: 1.0
Content-type: text/html
Subject: Daily Photos Backup Directory Listing

<h3>Directory Listing:</h3>
%s
	"""%mylist
	
    smtpObj = smtplib.SMTP(host='smtp.gmail.com', port=587)
    smtpObj.ehlo()
    smtpObj.starttls()
    smtpObj.ehlo()
    smtpObj.login('SENDER-EMAIL@gmail.com','PASSWORD')
    smtpObj.sendmail(sender, receivers, message)
    smtpObj.quit()
    print "Successfully sent email"
except smtplib.SMTPException,error:
    print str(error)
    print "Error: unable to send email"
