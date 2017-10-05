
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

resource "template_file" "ecs_task_es" {
  template = "${file("modules/ecs/templates/es.json")}"
}

resource "template_file" "ecs_task_kibana" {
    template = "${file("modules/ecs/templates/kibana.json")}"
    vars = {
        ELASTICSEARCH_URL = "${var.ELASTICSEARCH_URL}"
        ES_PORT = "${var.ES_PORT}"
        XPACK_MONITORING_ELASTICSEARCH_URL = "http://${var.ELASTICSEARCH_URL}:${var.ES_PORT}"
    }
}
