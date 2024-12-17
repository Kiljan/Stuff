#!/bin/bash

# TCP	Inbound	6443	Kubernetes API server	All
# TCP	Inbound	2379-2380	etcd server client API	kube-apiserver, etcd
# TCP	Inbound	10250	Kubelet API	Self, Control plane
# TCP	Inbound	10259	kube-scheduler	Self
# TCP	Inbound	10257	kube-controller-manager	Self
# TCP   Wave NET 6783

firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=2379-2380/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=10259/tcp --permanent
firewall-cmd --add-port=10257/tcp --permanent
firewall-cmd --add-port=6783/tcp --permanent

firewall-cmd --reload
