###############################
# VPC + Subnets
###############################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "devops-assessment-vpc"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "public-${count.index}" }
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "private-${count.index}" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "devops-assessment-igw" }
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

###############################
# EKS Cluster
###############################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.0"   # Use a stable version

  cluster_name    = "devops-assessment-eks"
  cluster_version = "1.29"
  subnets         = aws_subnet.private[*].id
  vpc_id          = aws_vpc.main.id

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  manage_aws_auth = true
}

###############################
# IAM Role for Service Account (IRSA)
###############################

resource "aws_iam_role" "app_role" {
  name = "todo-app-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
}

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:default:todo-app-sa"]
      variable = "${module.eks.oidc_provider}:sub"
    }
  }
}

###############################
# DynamoDB Table
###############################

resource "aws_dynamodb_table" "todos" {
  name           = "todos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  tags = { Name = "todos-table" }
}

# IAM Policy for DynamoDB access
resource "aws_iam_policy" "dynamodb_policy" {
  name   = "todo-app-dynamodb-policy"
  path   = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem","dynamodb:GetItem","dynamodb:Scan","dynamodb:UpdateItem"]
        Resource = aws_dynamodb_table.todos.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}
