#!/bin/bash

if [ "$#" -ne 1 ]
then
  echo "Error: No domain name argument provided"
  echo "Usage: Provide a domain name as an argument"
  exit 1
fi

DOMAIN=$1

openssl genrsa -out "${DOMAIN}.key" 2048

# Create csf conf

cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = "FR"
ST = "RHONE"
L = "LYON"
O = "ITSGROUP"
OU = "ITSSERVICE"
CN = "${DOMAIN}"

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${DOMAIN}
DNS.2 = www.${DOMAIN}
IP.1 = 192.168.20.10
IP.2 = 192.168.20.10

EOF

# create CSR request using private key

openssl req -new -key "${DOMAIN}.key" -out "${DOMAIN}.csr" -config csr.conf

# Create SSl with self signed CA

openssl x509 -req \
    -in "${DOMAIN}.csr" \
    -signkey "${DOMAIN}.key" \
    -days 365 \
    -sha256 \
    -out "${DOMAIN}.crt"


# Generate the pem file

cat "${DOMAIN}.key" "${DOMAIN}.crt" >> "${DOMAIN}.pem"