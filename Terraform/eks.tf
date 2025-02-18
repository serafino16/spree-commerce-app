resource "aws_eks_cluster" "main" {
  name     = "main-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id,
      aws_subnet.subnet_c.id,
    ]
    security_group_ids = [aws_security_group.eks_sec_group.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_role_policy]
}
