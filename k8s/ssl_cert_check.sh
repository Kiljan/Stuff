#!/bin/bash
for i in $( ls /etc/kubernetes/pki/ | grep crt ); do echo -n $i " " && openssl x509 -enddate -noout -in $i; done