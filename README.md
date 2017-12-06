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
1. Clone this repo
2. Install [Terraform](https://www.terraform.io/downloads.html)
3. Install [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
4. Configure the AWS CLI with your AWS credentials
5. Execute the Terraform plan

```sh
git clone git@github.com:cliffom/terraws.git
brew install terraform awscli
aws configure
terraform plan
terraform apply
```
