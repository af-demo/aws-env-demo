data "atlas_artifact" "webami" {
    name = "${var.atlas_org_name}/webami"
    type = "amazon.image"
    build = "latest"
}

resource "aws_launch_configuration" "demo_launch_conf" {
    lifecycle { create_before_destroy = true }
    image_id = "${data.atlas_artifact.webami.metadata_full.region-us-east-1}"
    instance_type = "${var.aws_instance_type}"
    security_groups = ["${aws_security_group.web_allow_http.id}"]

}

resource "aws_autoscaling_group" "demo_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
  load_balancers = ["${aws_elb.demoenv-elb.id}"]
  name = "asg-demoenv-${aws_launch_configuration.demo_launch_conf.name}"
  max_size = 2
  min_size = 0
  wait_for_elb_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.demo_launch_conf.id}"
  tag {
    key = "CostCenter"
    value = "DemoEnv"
    propagate_at_launch = true
  }
}
