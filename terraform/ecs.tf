##################
# Cluster
##################
resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my_ecs_cluster"
}


##################
# Task def
##################
resource "aws_ecs_task_definition" "my_flask_app_task" {
  family                   = "my_flask_app_task"
  network_mode             = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.my_ecs_access_role.arn
  task_role_arn = aws_iam_role.my_ecs_access_role.arn

  container_definitions = jsonencode([{
    name  = "my_flask_app_container",
    image = "<account id>.dkr.ecr.ap-southeast-2.amazonaws.com/my_flask_app:latest",
    portMappings = [{
      containerPort = 5000,
    }]
  }])
}


##################
# Service
##################
resource "aws_ecs_service" "my_flask_app" {
  name             = "my_flask_app"
  cluster          = aws_ecs_cluster.my_ecs_cluster.id
  task_definition  = aws_ecs_task_definition.my_flask_app_task.arn
  desired_count    = 1
  launch_type      = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.my_subnet_a.id, aws_subnet.my_subnet_b.id, aws_subnet.my_subnet_c.id]
    security_groups = [aws_security_group.my_sg_flask_app.id]
  }
}