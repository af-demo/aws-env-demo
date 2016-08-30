data "atlas_artifact" "webami" {
//    name = "${var.atlas_org_name}/webami"
    name = "af-hs-test/webami"
    type = "amazon.image"
    build = "latest"
}

resource "aws_launch_configuration" "demo_launch_conf" {
    name_prefix = "demoenv-lc-"
    image_id = "${data.atlas_artifact.webami.metadata_full.region-us-east-1}"
    instance_type = "${var.aws_instance_type}"
//    security_groups = [""]
    lifecycle {
      create_before_destroy = true
    }
}
