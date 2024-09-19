#!/usr/bin/env bash

# Run this script after Terraform has provisioned the EBS and EFS CSI controllers on EKS.
kubectl rollout restart deployment ebs-csi-controller -n kube-system
kubectl rollout restart deployment efs-csi-controller -n kube-system
