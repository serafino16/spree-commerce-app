resource "aws_iam_role" "alb_controller_role" {
  name = "alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "alb_controller_policy" {
  name       = "alb-controller-policy-attachment"
  roles      = [aws_iam_role.alb_controller_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_ALBControllerPolicy"
}
