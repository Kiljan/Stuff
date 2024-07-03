#!/bin/bash

# TCP	Inbound	10250	Kubelet API	Self, Control plane
# TCP	Inbound	30000-32767	NodePort Services†	All
# TCP   Wave NET 6783

firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=30000-32767/tcp --permanent
firewall-cmd --add-port=6783/tcp --permanent

firewall-cmd --reload
