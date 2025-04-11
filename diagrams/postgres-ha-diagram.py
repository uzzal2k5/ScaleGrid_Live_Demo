#!/usr/bin/env python3

"""
Author: [Md Shafiqul Islam, Deployment/Platform Automation Consultant, WhatsApp +8801715519132]
Date: [Mon 7 Apr 2025]
Description: This script visualizes the architecture of the ScaleGrid_Live_Demo project.
             It depicts two AWS EKS clusters with a PostgreSQL HA deployment spanning both clusters.
"""

from diagrams import Diagram, Cluster
from diagrams.aws.compute import EKS
from diagrams.k8s.compute import Pod
from diagrams.k8s.storage import PersistentVolumeClaim
from diagrams.k8s.network import Service
from diagrams.onprem.database import PostgreSQL

with Diagram("ScaleGrid Live Demo Architecture", show=True, direction="TB"):
    with Cluster("AWS Cloud"):
        with Cluster("EKS Cluster 1"):
            eks1 = EKS("eks-cluster-1")
            with Cluster("PostgreSQL HA Deployment"):
                pg_master = Pod("PostgreSQL Master")
                svc_master = Service("Master Service")
                pvc_master = PersistentVolumeClaim("Master PVC")
                pg_master >> svc_master
                pg_master >> pvc_master

        with Cluster("EKS Cluster 2"):
            eks2 = EKS("eks-cluster-2")
            with Cluster("PostgreSQL HA Deployment"):
                pg_replica = Pod("PostgreSQL Replica")
                svc_replica = Service("Replica Service")
                pvc_replica = PersistentVolumeClaim("Replica PVC")
                pg_replica >> svc_replica
                pg_replica >> pvc_replica

    # Cross-cluster replication
    pg_master >> PostgreSQL("Replication") >> pg_replica
