resource "aws_route53_zone" "main" {
  name = "gordemo.local"
  vpc_id = "${var.aws_vpc}"

  tags {
    Environment = "main"
  }

}


resource "aws_route53_record" "es" {
   zone_id = "${aws_route53_zone.main.zone_id}"
   name = "es"
   type = "A"

   alias {
    name = "${aws_elb.internal-elb.dns_name}"
    zone_id = "${aws_elb.internal-elb.zone_id}"
    evaluate_target_health = true
  }
}
