resource "aws_iam_role" "redis_role" {
  name               = "redis-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "elasticache.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "redis_policy" {
  name        = "redis-access-policy"
  description = "Allow access to ElastiCache Redis"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "elasticache:Describe*"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "elasticache:Connect"
        Effect    = "Allow"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "redis_policy_attachment" {
  name       = "redis-access-policy-attachment"
  policy_arn = aws_iam_policy.redis_policy.arn
  roles      = [aws_iam_role.redis_role.name]
}
