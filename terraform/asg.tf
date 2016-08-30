resource "atlas_artifact" "web-ami" {
  name = "${var.atlas_org_name}/webami"
  type = "amazon.image"
  version = "latest"
}
resource "aws_launch_configuration" "demo_launch_conf" {
    name_prefix = "demoenv-lc-"
    image_id = "${atlas_artifact.web-ami.metadata_full.region-us-east-1}"
    instance_type = "${var.aws_instance_type}"
//    security_groups = [""]
    lifecycle {
      create_before_destroy = true
    }
}
