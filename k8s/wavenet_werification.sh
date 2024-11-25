#!/bin/bash

echo "master-new"
kubectl exec -n kube-system weave-net-r8wn9 -c weave -- /home/weave/weave --local status
kubectl exec -n kube-system weave-net-r8wn9 -c weave -- /home/weave/weave --local status connections

echo "node-new-1"
kubectl exec -n kube-system weave-net-ls4z9 -c weave -- /home/weave/weave --local status
kubectl exec -n kube-system weave-net-ls4z9 -c weave -- /home/weave/weave --local status connections

echo "node-new-2"
kubectl exec -n kube-system weave-net-f4mng -c weave -- /home/weave/weave --local status
kubectl exec -n kube-system weave-net-f4mng -c weave -- /home/weave/weave --local status connections

echo "node-new-3"
kubectl exec -n kube-system weave-net-4xbzd -c weave -- /home/weave/weave --local status
kubectl exec -n kube-system weave-net-4xbzd -c weave -- /home/weave/weave --local status connections
