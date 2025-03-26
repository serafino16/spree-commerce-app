resource "aws_iam_role" "rds_iam_role" {
  name               = "rds-iam-auth-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rds_iam_policy_attachment" {
  name       = "rds-iam-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
  roles      = [aws_iam_role.rds_iam_role.name]
}
