#!/bin/bash

##Disable compiler Access
echo "Disabling compiler Access...."
/scripts/compilers off

##update Nameservers and contact email.
echo "Updating Nameservers and contact email..."
whmapi1 update_contact_email contact_email=user%40example.com
whmapi1 update_nameservers_config nameserver=ns1.uswhss.org
whmapi1 update_nameservers_config nameserver2=ns2.uswhss.com

##Install pure-ftpd
echo "Installing pure-ftpd..."
/usr/local/cpanel/scripts/setupftpserver --force pure-ftpd

##Install and enable "lsapi" for PHP versions.
echo "Installing and enabling "lsapi" for PHP versions..."
yum install ea-apache24-mod_lsapi.x86_64
whmapi1 php_set_handler version=ea-php71 handler=lsapi
whmapi1 php_set_handler version=ea-php72 handler=lsapi
whmapi1 php_set_handler version=ea-php73 handler=lsapi
whmapi1 php_set_handler version=ea-php74 handler=lsapi

##Install and enable mod_security
echo "Installing and enabling mod_security..."
/usr/local/cpanel/scripts/modsec_vendor add http://httpupdate.cpanel.net/modsecurity-rules/meta_OWASP3.yaml

##Disable stats programs (Awstats, Analog and Webalize)
##https://docs.cpanel.net/knowledge-base/cpanel-product/the-cpanel-config-file/
echo "Disabling stats programs (awstats, analog stats etc)..."
whmapi1 set_tweaksetting key=skipawstats value=1
whmapi1 set_tweaksetting key=skipanalog value=1
whmapi1 set_tweaksetting key=skipwebalizer value=1

##Mail settings
echo "Tweaking mail settings..."
whmapi1 set_tweaksetting key=maxemailsperhour value=250
whmapi1 set_tweaksetting key=defaultmailaction value=fail
whmapi1 set_tweaksetting key=domainowner_mail_pass value=1
whmapi1 set_tweaksetting key=eximmailtrap value=1
whmapi1 set_tweaksetting key=email_outbound_spam_detect_action value=block

##Install csf
cd /usr/local/src/; wget https://download.configserver.com/csf.tgz; tar -zxf csf.tgz; cd csf; sh install.sh; 
sed -i 's|TESTING = "1"|TESTING = "0"|g' /etc/csf/csf.conf
csf -r

echo "Done!!"