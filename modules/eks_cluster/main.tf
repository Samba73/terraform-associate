# eks cluster
## eks cluster role
data "aws_iam_policy_document" "cluster_assume_role"{
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRole"]
      principals {
        type = "Service"
        identifiers = ["eks.amazonaws.com"]
      }
    }
}
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster.name
}
data "aws_vpc" "default" {
    default = true
}
data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}
#eks cluster
resource "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version = "1.28"

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }
  depends_on = [ aws_iam_role_policy_attachment.AmazonEKSClusterPolicy ]
}
# eks cluster node
## els cluster node role (ec2 trust permission)
data "aws_iam_role_policy_document" "node_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}
resource "aws_iam_role" "node_group" {
  name = "${var.cluster_name}-node-group"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_group.name
  
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.node_group.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node_group.name
}
# eks node group


