resource "aws_launch_configuration" "worker_launch_config" {
  name          = "worker-launch-config"
  image_id      = "ami"  
  instance_type = "t3.medium"     

  security_groups = [aws_security_group.worker_sec_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
  launch_configuration = aws_launch_configuration.worker_launch_config.id
  health_check_type    = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "Name"
    value               = "worker-node"
    propagate_at_launch = true
  }

  depends_on = [aws_security_group.worker_sec_group]
}
