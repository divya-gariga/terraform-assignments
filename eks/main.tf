resource "aws_eks_cluster" "ex-cluster-div" {
    name ="ex-cluster-tf-div"
    role_arn = aws_iam_role.eks-cluster-role.arn
    vpc_config {
      subnet_ids = [ "subnet-08210e4584335dfda","subnet-051b703b3e3db09a5"]
    }
    depends_on = [
      aws_iam_role.eks-cluster-role
    ]
}

# creating cluster role
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role-tf-div"
  assume_role_policy = file("cluster-trust-policy.json")
}

resource "aws_iam_role_policy_attachment" "attach-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# creating node role
resource "aws_iam_role" "eks-node-role" {
  name = "eks-node-role-tf-div"
   assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "attach-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}
resource "aws_iam_role_policy_attachment" "attach-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}
resource "aws_iam_role_policy_attachment" "attach-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

# creating node group
resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.ex-cluster-div.name
  node_group_name = "ex-cluster-tf-div-workernodes"
  node_role_arn  = aws_iam_role.eks-node-role.arn
  subnet_ids = [ "subnet-08210e4584335dfda","subnet-051b703b3e3db09a5"]
  instance_types = ["t2.small"]
 
  scaling_config {
   desired_size = 1
   max_size   = 2
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role.eks-node-role,
  ]
 }
