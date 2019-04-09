#!/bin/bash
BAHMNI_CERT_DIR=""
KEYSTORE_PASSWORD=""
METABASE_SSL_DIR="/etc/metabase/ssl"
PKCS12_FILE_NAME="metabase.local.p12"
METABASE_SSL_FILE_NAME="metabase_ssl.jks"

echo "This script converts existing bahmni ssl(generated using Let's Encrypt) to jks format and assumes 'Let's Encrypt' and Java environments available"
if [ "$1" != "" ] || [ "$2" != "" ]; then
	BAHMNI_CERT_DIR="$1"
	KEYSTORE_PASSWORD="$2"
	mkdir -p /etc/metabase/ssl
	openssl pkcs12 -export -in "${BAHMNI_CERT_DIR}/cert.pem" -inkey "${BAHMNI_CERT_DIR}/privkey.pem" -out "${METABASE_SSL_DIR}/${PKCS12_FILE_NAME}" -password pass:"${KEYSTORE_PASSWORD}"
	keytool -importkeystore -srckeystore "${METABASE_SSL_DIR}/${PKCS12_FILE_NAME}" -srcstoretype pkcs12 -srcstorepass "${KEYSTORE_PASSWORD}" -destkeystore "${METABASE_SSL_DIR}/${METABASE_SSL_FILE_NAME}" -deststoretype jks -deststorepass "${KEYSTORE_PASSWORD}"
	echo "java key store file created at the location ${METABASE_SSL_DIR}/${METABASE_SSL_FILE_NAME}"
else
	echo "No bahmni certificates directory or keystore password provided. Usage: ./pemtojks.sh /etc/letsencrypt/live/dev.bahmnidev.org password"
fi
