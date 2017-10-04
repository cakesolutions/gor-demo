
resource "template_file" "ecs_task_hello-world" {
    template = "${file("modules/ecs/templates/hello-world.json")}"
}

resource "template_file" "ecs_task_goreplay" {
    template = "${file("modules/ecs/templates/goreplay.json")}"
}

resource "template_file" "ecs_instance_role_policy" {
    template = "${file("modules/ecs/templates/ecs-instance-role-policy.json")}"
}

resource "template_file" "ecs_role" {
    template = "${file("modules/ecs/templates/ecs-role.json")}"
}

resource "template_file" "user_data" {
  template = "${file("modules/ecs/templates/user_data.sh")}"
  vars = {
      ecs_cluster_name = "${var.cluster}"
  }
}
