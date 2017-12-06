# terraws - Basic Terraform AWS Example

## Purpose
To demonstrate a working knowledge of [Terraform](https://www.terraform.io/) w/ [AWS](https://aws.amazon.com/).

## Expected Results
The output of these Terraform scripts will be a AWS ELB DNS name (`elb_dns_name`) available to all users. HTTP requests made to `elb_dns_name` will result in the following output (unique per instance serving the request):

* instance_id
* instance_type
* local-ipv4
* placement/availability-zone
* ami-id

The following AWS services are created:

* Elastic Load Balancer
* EC2 Launch Configuration
* EC2 Auto-Scaling Group
* VPC
  * Subnet
  * Internet Gateway
  * Routing Table

## Getting started
1. Install [Terraform](https://www.terraform.io/downloads.html)
2. Install [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
3. Clone this repo
4. Configure the AWS CLI with your AWS credentials
5. Execute the Terraform plan

```sh
brew install terraform awscli
git clone git@github.com:cliffom/terraws.git
cd terraws
aws configure
terraform plan
terraform apply
```

When `terraform apply` is complete, you will see `elb_dns_name` with a value in the output. After a few moments that DNS name will respond to HTTP GET requests with the expected output outlined above.
