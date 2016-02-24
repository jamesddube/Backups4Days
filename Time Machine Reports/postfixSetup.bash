#!/bin/bash

# Postfix setup script to send mail via Gmail from a Mac


# usage:
# sudo chmod +x ./postfixSetup.bash
# sudo ./postfixSetup.bash youremail@gmail.com 'password'

cp /etc/postfix/main.cf ~/main.cf.back  # backup just in case

echo [smtp.gmail.com]:587 $1:$2 >> /etc/postfix/sasl_passwd

# update main.cf with new settings for Gmail
echo relayhost = [smtp.gmail.com]:587 >> /etc/postfix/main.cf
echo smtp_sasl_auth_enable = yes >> /etc/postfix/main.cf
echo smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd >> /etc/postfix/main.cf
echo smtp_sasl_security_options = noanonymous >> /etc/postfix/main.cf
echo smtp_use_tls = yes >> /etc/postfix/main.cf
echo smtp_sasl_mechanism_filter = plain >> /etc/postfix/main.cf

chmod 600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
launchctl stop org.postfix.master
launchctl start org.postfix.master

#test it
#  ls | mail -s "SUBJECT" your@yourdomain.com
