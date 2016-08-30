resource "aws_security_group" "web_allow_http" {
  name = "web_allow_http"
  vpc_id = "${aws_vpc.demovpc.id}"
  description = "Allow inbound HTTP traffic from ELB"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = ["${aws_security_group.elb_allow_http.id}"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "web_allow_http"
  }
}

resource "aws_security_group" "elb_allow_http" {
  name = "elb_allow_http"
  vpc_id = "${aws_vpc.demovpc.id}"
  description = "Allow inbound HTTP traffic"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "elb_allow_http"
  }
}
