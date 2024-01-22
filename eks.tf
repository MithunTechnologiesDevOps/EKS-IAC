resource "aws_eks_cluster" "main" {

  name     = "${var.project_name}-${var.environmnet}-cluster"
  version  = "1.28"
  role_arn = aws_iam_role.clusterrole.arn

  vpc_config {
    subnet_ids              = flatten([aws_subnet.publicsubnets[*].id, aws_subnet.privatesubents[*].id, ])
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-cluster"
  })

  depends_on = [aws_iam_role_policy_attachment.clusterroleattachment]
}

resource "aws_iam_role" "clusterrole" {

  name               = "${var.project_name}-${var.environmnet}-clusterrole"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-cluster-role"
  })
}

resource "aws_iam_role_policy_attachment" "clusterroleattachment" {
  role       = aws_iam_role.clusterrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_node_group" "nodegroup" {

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environmnet}-cluster-nodegroup"
  subnet_ids      = aws_subnet.privatesubents[*].id
  node_role_arn   = aws_iam_role.workerrole.arn

  scaling_config {
    desired_size = var.nodegroup_desired_size
    min_size     =  var.nodegroup_min_size
    max_size     = var.nodegroup_max_size
  }

  update_config {
    max_unavailable = 1
  }
  ami_type       = "AL2_x86_64"
  disk_size      = 20
  capacity_type  = "ON_DEMAND"
  instance_types = [var.nodegroup_instance_type]


  depends_on = [aws_iam_role_policy_attachment.workerrolepolicyattachment]

  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-cluster-nodegroup"
  })

}

resource "aws_iam_role" "workerrole" {
  name               = "${var.project_name}-${var.environmnet}-workerrole"
  assume_role_policy = data.aws_iam_policy_document.work_assume_role.json

  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-workerrole"
  })
}

resource "aws_iam_role_policy_attachment" "workerrolepolicyattachment" {
  for_each   = var.eks_node_policies
  role       = aws_iam_role.workerrole.name
  policy_arn = each.value
}

