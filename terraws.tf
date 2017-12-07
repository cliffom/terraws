provider "aws" {
  region = "us-east-1"
}

## Creating Launch Configuration
resource "aws_launch_configuration" "web" {
  image_id        = "ami-55ef662f"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.web.id}"]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    service docker start

    COMMAND="curl -s"
    AWS_META_BASE=http://169.254.169.254/latest/meta-data
    COMMAND_BASE="curl -s $AWS_META_BASE"
    NGINX_ROOT=/usr/share/nginx/html
    INDEX_FILE=$NGINX_ROOT/index.html
    mkdir -p $NGINX_ROOT

    INSTANCE_ID=`$COMMAND_BASE/instance-id`
    INSTANCE_TYPE=`$COMMAND_BASE/instance-type`
    INSTANCE_IP=`$COMMAND_BASE/local-ipv4`
    INSTANCE_AZ=`$COMMAND_BASE/placement/availability-zone`
    INSTANCE_AMI=`$COMMAND_BASE/ami-id`

    echo "<pre>" > $INDEX_FILE
    echo $INSTANCE_ID >> $INDEX_FILE
    echo $INSTANCE_TYPE >> $INDEX_FILE
    echo $INSTANCE_IP >> $INDEX_FILE
    echo $INSTANCE_AZ >> $INDEX_FILE
    echo $INSTANCE_AMI >> $INDEX_FILE
    echo "</pre>" >> $INDEX_FILE

    docker run --name nginx -d -v $NGINX_ROOT:$NGINX_ROOT -p 8080:80 nginx
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = "${aws_launch_configuration.web.id}"
  vpc_zone_identifier  = ["${aws_subnet.web-us-east-1a.id}", "${aws_subnet.web-us-east-1b.id}", "${aws_subnet.web-us-east-1c.id}"]
  min_size             = 3
  max_size             = 6
  load_balancers       = ["${aws_elb.web.name}"]
  health_check_type    = "ELB"
}

resource "aws_elb" "web" {
  name            = "terraws"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets         = ["${aws_subnet.elb-us-east-1a.id}", "${aws_subnet.elb-us-east-1b.id}", "${aws_subnet.elb-us-east-1c.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:8080/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "8080"
    instance_protocol = "http"
  }
}

output "elb_dns_name" {
  value = "${aws_elb.web.dns_name}"
}
