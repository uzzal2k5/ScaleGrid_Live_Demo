#!/usr/bin/env python3
# Author: [Md Shafiqul Islam, Deployment/Platform Automation Consultant, WhatsApp +8801715519132]
# Date: [Mon 7 Apr 2025]
# Description: This Python code creates a visual representation of a Highly Available Multi-Region
#              EKS Architecture with PostgreSQL HA Cluster using the 'diagrams' library.
#              The architecture spans two AWS regions (us-east-1 and us-east-2), with VPCs,
#              subnets, EKS clusters, PostgreSQL pods, persistent volumes, security groups,
#              load balancers, and cross-region replication using VPC peering.
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.network import VPC, PrivateSubnet,PublicSubnet,PublicSubnet, InternetGateway, NATGateway, ELB
# from diagrams.aws.network import VPC, VPNGateway, TransitGateway
from diagrams.aws.compute import EKS, EC2
from diagrams.aws.general import Users
from diagrams.k8s.compute import Pod
from diagrams.k8s.storage import PersistentVolume, PersistentVolumeClaim
from diagrams.k8s.network import Service


with Diagram("Highly Available Multi-Region EKS Architecture and PostgreSQL HA Cluster ", show=True, direction="LR"):
    client = Users("Client")
    with Cluster("AWS"):
        # --------------------- Region: us-east-1 ---------------------
        with Cluster("us-east-1"):
            with Cluster("vpc_1"):
                igw1 = InternetGateway("IGW")
                nat1 = NATGateway("NAT GW")
                east_lb1 = ELB("us-east-1 ELB")
                sg1 = EC2("sg for eks1")

                with Cluster("Public Subnet"):
                    public1a = PublicSubnet("Public Subnet 1a")
                    public1b = PublicSubnet("Public Subnet 1b")

                with Cluster("Private Subnet"):
                    with Cluster("eks1 - Node Group"):
                        # node 1a
                        node1a = EC2("node-1a")
                        postgres1a = Pod("PostgreSQL Pod 1a")
                        pvc1a = PersistentVolumeClaim("PVC 1a")
                        pv1a = PersistentVolume("PV 1a")
                        # node 1b
                        node1b = EC2("node-1b")
                        postgres1b = Pod("PostgreSQL Pod 1b")
                        pvc1b = PersistentVolumeClaim("PVC 1b")
                        pv1b = PersistentVolume("PV 1b")
                        # Kubernetes SVC
                        postgres_svc1 = Service("PostgreSQL Master")

                eks1 = EKS("eks1")
                vpc1 = VPC("vpc_1")

                eks1 << node1a >> postgres1a >> pvc1a >> pv1a >> postgres_svc1 << sg1
                eks1 << node1b >> postgres1b >> pvc1b >> pv1b >> postgres_svc1 << sg1
                nat1 << node1a << vpc1
                nat1 << node1b << vpc1
                igw1 >> public1a >> vpc1
                igw1 >>public1b >> vpc1
                client >> east_lb1 >> eks1 << sg1
        # --------------------- Region: us-east-2 ---------------------
        with Cluster("us-east-2"):
            with Cluster("vpc_2"):
                igw2 = InternetGateway("IGW")
                nat2 = NATGateway("NAT GW")
                east_lb2 = ELB("us-east-2 ELB")
                sg2 = EC2("sg for eks2")

                with Cluster("Public Subnet"):
                    public2a = PublicSubnet("Public Subnet 2a")
                    public2b = PublicSubnet("Public Subnet 2b")

                with Cluster("Private Subnet"):
                    with Cluster("eks2 - Node Group"):
                        # node 2a
                        node2a = EC2("node-2a")
                        postgres2a = Pod("PostgreSQL Pod 2a")
                        pvc2a = PersistentVolumeClaim("PVC 2a")
                        pv2a = PersistentVolume("PV 2a")
                        # node 2b
                        node2b = EC2("node-2b")
                        postgres2b = Pod("PostgreSQL Pod 2b")
                        pvc2b = PersistentVolumeClaim("PVC 2b")
                        pv2b = PersistentVolume("PV 2b")
                        # Kubernetes SVC
                        postgres_svc2 = Service("PostgreSQL Replica")
                eks2 = EKS("eks2")
                vpc2 = VPC("vpc_2")

                eks2<< node2a >> postgres2a >> pvc2a >> pv2a >> postgres_svc2 << sg2
                eks2 << node2b >> postgres2b >> pvc2b >> pv2b >> postgres_svc2 << sg2
                nat2 << node2a << vpc2
                nat2 << node2b << vpc2
                igw2 >> public2a >> vpc2
                igw2 >>public2b >> vpc2
                client >> east_lb2 >> eks2 << sg2
        # --------------------- Security Group Rules ---------------------
        sg1_rule = Edge(color="blue", style="dashed", label="") # Allow EKS1 to EKS2 PostgreSQL (5432)
        sg2_rule = Edge(color="blue", style="dashed", label="") # Allow EKS2 to EKS1 PostgreSQL (5432)

        sg1 >> sg1_rule >> sg2
        sg2 >> sg2_rule >> sg1

        # --------------------- Cross-Region VPC Peering ---------------------
        vpc1_to_vpc2 = Edge(color="green", style="dashed", label="VPC Peering")
        vpc1 >> vpc1_to_vpc2 >> vpc2

        # --------------------- Security Group Binding ---------------------
        # Binding SG1 to SG2 and SG2 to SG1
        sg1_binding = Edge(color="red", style="solid", label="") # SG1 binds to SG2
        sg2_binding = Edge(color="red", style="solid", label="") # SG2 binds to SG1

        sg1 >> sg1_binding >> sg2
        sg2 >> sg2_binding >> sg1


