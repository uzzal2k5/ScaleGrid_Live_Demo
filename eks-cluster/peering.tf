resource "aws_vpc_peering_connection" "peer" {
  provider = aws.region1  # Ensure provider is correctly set
  vpc_id        = module.vpc_1.vpc_id  # First VPC
  peer_vpc_id   = module.vpc_2.vpc_id  # Second VPC
  peer_region   = var.regions[1]  # Specify the correct region of the second VPC
  auto_accept   = false  # Must be false if different accounts
  tags = {
    Name = "vpc-peering-${var.project}"
  }
  depends_on = [module.vpc_1]  # Ensure VPC is created before EKS
}

# Accept peering connection in the second region
resource "aws_vpc_peering_connection_accepter" "peer_accept" {
provider                  = aws.region2  # Use correct provider
vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
auto_accept               = true
tags = {
Name = "vpc-peering-accept-${var.project}"
}
  depends_on = [module.vpc_2]  # Ensure VPC is created before EKS
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.region1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.region2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}


# Route table for VPC1
resource "aws_route" "route_vpc1_to_vpc2" {
  provider               = aws.region1
  # route_table_id         = var.vpc1_route_table_id
  route_table_id = module.vpc_1.private_route_table_ids[0]
  destination_cidr_block = var.vpc_cidr_blocks["vpc_2"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [module.vpc_1]  # Ensure VPC is created before EKS
}

# Route table for VPC2
resource "aws_route" "route_vpc2_to_vpc1" {
  provider               = aws.region2
  # route_table_id         = var.vpc2_route_table_id
  route_table_id = module.vpc_2.private_route_table_ids[0]
  destination_cidr_block = var.vpc_cidr_blocks["vpc_1"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [module.vpc_2]  # Ensure VPC is created before EKS
}

