#!/bin/bash

kubectl apply -f 1_volume_provisioned_manually.yaml
kubectl apply -f 2_ConfigMap_set_TODO.yaml
kubectl apply -f 3_autoscaling.yaml
kubectl apply -f 4_Secret_Passwd.yaml
kubectl apply -f deployment_TODO.yaml
kubectl apply -f service.yaml
