resource "aws_launch_configuration" "ecs_lc" {
    name_prefix     = "${var.env}_${var.cluster}-"
    image_id             = "${var.aws_ami}"
    instance_type        = "${var.instance_type}"
    security_groups      = ["${aws_security_group.ecs_sg.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
    user_data            = "${template_file.user_data.rendered}"
    key_name             = "${var.key_name}"

    lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${var.env}_${var.cluster}-asg"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  health_check_grace_period = 300
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.ecs_lc.id}"
  vpc_zone_identifier  = "${var.vpc_subnets_id}"

  tag {
    key                 = "Name"
    value               = "${var.env}_ecs_${var.cluster}-asg"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Cluster"
    value               = "${var.cluster}"
    propagate_at_launch = "true"
  }


}



resource "aws_ecs_cluster" "ecs" {
    name = "${var.cluster}"
}

resource "aws_ecs_service" "ecs_service_hello-world" {
  name            = "ecs_service_hello-world"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_hello-world.arn}"
  desired_count   = 3
  iam_role        = "${aws_iam_role.ecs_role.arn}"

  placement_strategy {
    type  = "spread"
    field = "host"
  }

  load_balancer {
      target_group_arn = "${aws_alb_target_group.ecs_target.arn}"
      container_name = "hello-world"
      container_port = 80
    }
  }

resource "aws_ecs_task_definition" "ecs_task_hello-world" {
  family = "hello-world"
  container_definitions = "${template_file.ecs_task_hello-world.rendered}"
}

resource "aws_ecs_service" "ecs_service_goreplay" {
  name            = "ecs_service_goreplay"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_goreplay.arn}"
  desired_count   = 3


  placement_strategy {
    type  = "spread"
    field = "host"
  }
}

resource "aws_ecs_task_definition" "ecs_task_goreplay" {
  family = "goreplay"
  container_definitions = "${template_file.ecs_task_goreplay.rendered}"
  network_mode = "host"
}
