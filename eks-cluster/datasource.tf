data "aws_availability_zones" "available_vpc1" {
  provider = aws.region1
  state    = "available"  # ✅ Ensure only valid zones are selected
}
data "aws_availability_zones" "available_vpc2" {
  provider = aws.region2
  state    = "available"  # ✅ Ensure only valid zones are selected
}

