#!/bin/bash -e

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Mounting the secrets that we have as files
echo ">> Secrets and Configs Manipulation <<"
cp /opt/fts3/fts3-host-pems/hostcert.pem /etc/grid-security/
cp /opt/fts3/fts3-host-pems/hostcert.pem /etc/pki/tls/certs/localhost.crt
chmod 644 /etc/grid-security/hostcert.pem
chmod 644 /etc/pki/tls/certs/localhost.crt
chown root:root /etc/grid-security/hostcert.pem
chown root:root /etc/pki/tls/certs/localhost.crt

cp /opt/fts3/fts3-host-pems/hostkey.pem /etc/grid-security/
cp /opt/fts3/fts3-host-pems/hostkey.pem /etc/pki/tls/private/localhost.key
chmod 400 /etc/grid-security/hostkey.pem
chmod 400 /etc/pki/tls/private/localhost.key
chown root:root /etc/grid-security/hostkey.pem
chown root:root /etc/pki/tls/private/localhost.key

# Process configs using envsubst to keep configs public
envsubst < /opt/fts3/fts3-configs/fts3config > /etc/fts3/fts3config
#envsubst < /opt/fts3/fts3-configs/fts3restconfig > /etc/fts3/fts3restconfig
envsubst < /opt/fts3/fts3-configs/fts-activemq.conf > /etc/fts3/fts-activemq.conf

#chown root:apache /etc/fts3web/fts3web.ini
#chown -R fts3:fts3 /var/log/fts3rest
chown -R fts3:fts3 /var/log/fts3
#chown -R fts3:fts3 /var/log/fts3web


if [[ ! -z "${DATABASE_UPGRADE}" ]]; then
   echo ">> Database Upgrade <<"
   yes Y | python /usr/share/fts/fts-database-upgrade.py
fi

#echo ">> Set FTS3 Aliases <<"
#python3 /opt/fts3/cluster-hostname-aliasing.py

# Remove TLSv1.3 support from monitoring server config : See https://its.cern.ch/jira/browse/FTS-2037 for more information
#sed -i -e 's^SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1^SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1 -TLSv1.3^g' /etc/httpd/conf.d/ftsmon.conf

# Add a ServerName to the HTTPD configuration
#echo ">> Creating /etc/httpd/conf.d/fqdn.conf <<"
#echo "ServerName localhost" > /etc/httpd/conf.d/fqdn.conf

#! HERE: Do we need to run again? It fails to execute but this is an init container process already (okd)
# echo ">> START fetch-crl <<"
# fetch-crl  

#echo ">> START httpd <<"                                                      
#httpd

#echo ">> EXEC restart_httpd.sh <<"
#echo 'while true; do sleep 3600; &>/dev/null httpd -k graceful; done' > /root/restart_httpd.sh
#chmod +x /root/restart_httpd.sh
#nohup /root/restart_httpd.sh &

echo ">> START supervisord <<"
supervisord -c /etc/supervisord.conf --nodaemon
