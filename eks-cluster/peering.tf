resource "aws_vpc_peering_connection" "peer" {
provider = aws.region1  # Ensure provider is correctly set

vpc_id        = module.vpc_1.vpc_id  # First VPC
peer_vpc_id   = module.vpc_2.vpc_id  # Second VPC
# peer_owner_id = data.aws_caller_identity.current.account_id  # Ensure it's correct
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
