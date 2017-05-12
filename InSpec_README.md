TOOLS
===========
Terraform
Test Kitchen
InSpec
kitchen-terraform


PRE-REQUISITES
=======================
Make sure you have the following prerequisites for this tutorial
An AWS Account
An AWS Access Key ID
An AWS Secret Key
An AWS Keypair
Terraform installed
Bundler installed
Ruby 2.3.1
The default security group on your account must allow SSH access from your IP address

So let's start building this config from scratch!

Setting up our development environment

First, let's create a new directory for our config:

$ mkdir terraform

And cd into that directory:

$ cd terraform

Now, create some skeleton terraform files:

$ touch main.tf 

Initialize Kitchen:

$ kitchen init --driver=kitchen-terraform  --create-gemfile

Setting up Test Kitchen
Now let's set up Test Kitchen.
Go ahead and open your .kitchen.yml file:

$ vim .kitchen.yml

Let's go ahead and add in configuration for for both Test Kitchen and kitchen-terraform in the .kitchen.yml config file.
And, last, let's add a test suite to 

.kitchen.yml:

---
driver:
  name: terraform

provisioner:
  name: terraform
  variable_files:
    - testing.tfvars

platforms:
  - name: ubuntu

transport:
  name: ssh
  ssh_key: ~/path/to/your/private/aws/key.pem

verifier:
  name: terraform
  format: doc
  groups:
    - name: default
      controls:
        - operating_system
      hostnames: public_dns
      username: ubuntu

suites:
  - name: default

  
  
  Save and close the file.

  
  
WRITING A TEST (Inspec)
============================

Now, we have some work to do on our workstation. First, let's set up an inspec directory within our test directories

$ mkdir -p test/integration/default/controls

This will be our default group of tests. Now we need to provide a yml file with the name of that group within the group directory. Go ahead and create this:

$ vim test/integration/default/inspec.yml

And add this content:

---
name: default

Save and close the file.

Now, just one more bit of housekeeping. Our .kitchen.yml is expecting an output of our test kitchen instances' hostnames within the output variable, public_dns. In order to have a hostname within that public_dns variable, we need to create an EC2 instance.
First, open up the main config file:

$ vim main.tf

And add this content:

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_instance" "example" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
}


Save and close the file. Notice that we used 

some variable values there? We need to add these into our variables.tf file.
Go ahead and create it.

$ vim variables.tf

And add in this content:

variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "region" {}
variable "ami" {}
variable "instance_type" {}\

And, finally, we need to add in some values for these variables.

Open up your testing.tfvars file:

$ vim testing.tfvars

And add in this content (substitute in the appropriate values for your AWS account, region, etc.)

access_key = "my_aws_access_key"
secret_key = "my_aws_secret_key"
key_name = "my_aws_key_pair_name"
region = "ap-south-1"
ami = "ami-618fab04"
instance_type = "m3.medium"


Save and close the file.


Finally, let's define that output that will be expected by our .kitchen.yml.


Go ahead and open up your output.tf file.

$ vim output.tf

And add this content:


output "public_dns" {
  value = "${aws_instance.example.public_dns}"
}


Ok! Now we're ready to finally create some 

Test Kitchen instances!

Go ahead and run:

$ bundle exec kitchen converge

Let's first try running the tests as is - even though we haven't written any yet.

$ bundle exec kitchen verify

And if it runs successfully, you should see output that includes:
0 examples, 0 failures


Let's add some tests!
Open up the file

$ vim test/integration/default/controls/operating_system_spec.rb

And let's add in a very basic test to make sure we are running on an Ubuntu system.

control 'operating_system' do
  describe service('ssh') do
    its { should be_installed }
  end
end


Now save and close the file and run the tests:

$ bundle exec kitchen verify

$ bundle exec kitchen destroy

