##################
# Policy
##################
resource "aws_iam_policy" "my_ecs_policy" {
  name        = "my_ecs_policy"
  description = "Policy for ECS to access ECR and cloudwatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ],
        Resource = "*"
      }
    ]
  })
}


##################
# Role
##################
resource "aws_iam_role" "my_ecs_access_role" {
  name = "my_ecs_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


##################
# Role -> Policy attachemnt
##################
resource "aws_iam_policy_attachment" "my_ecs_role_policy_att" {
  name       = "my_ecs_role_policy_att"
  policy_arn = aws_iam_policy.my_ecs_policy.arn
  roles      = [aws_iam_role.my_ecs_access_role.name]
}