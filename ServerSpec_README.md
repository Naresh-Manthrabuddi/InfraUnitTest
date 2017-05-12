# Steps for Serverspec tests.
Thsese steps shows the installation of terraform,serverspec and verifying the tests.

#  Installation of terraform 
Download the terraform 0.7 from the terraform website
[Terraform]( https://releases.hashicorp.com/terraform/0.7.13/terraform_0.7.13_linux_amd64.zip)

```bash
sudo mkdir -p /opt/terraform
sudo unzip path/to/zip-file.zip -d /opt/terraform
```
 add this line to ~/.bashrc:
 
 ```bash
export PATH="/opt/terraform:$PATH"
```

## Setting up our development environment

First, let's create a new directory for our config:

```bash
$ mkdir ServerSpecTest
```

Create ServerSpecTest folder:

```bash
$ cd ServerSpecTest
```


Add in a `Gemfile`:

```bash
$ vim Gemfile
```

Edit the `Gemfile ` and add in the `kitchen-terraform` gem like so:

```ruby
ruby '2.3.1'

source 'https://rubygems.org/' do
  gem 'test-kitchen'
  gem 'kitchen-terraform'
  gem 'kitchen-verifier-shell'
end
```

Close and save the file then run `bundler` to install these gems:

```bash
$ bundle install
```

Run kitchen init in the directory for the kitchen structure to be created.
```bash
$ kitchen init
```
Open your .kitchen.yml and add the following lines
```bash
---
driver:
  name: terraform
provisioner:
  name: terraform
platforms:
  - name: ubuntu-16.04
```

Create a folder with name serverpec and add the two files spec_helper.rb,yourserverspectestfilename_spec.rb

```bash
mkdir serverspec
$ touch spec_helper.rb,yourserverspectestfilename_spec.rb
```

Add the following contents to spec_helper.rb
```bash
require 'serverspec'

set :backend, :ssh

options = Net::SSH::Config.for(host)
options[:host_name] = ENV['KITCHEN_HOSTNAME']
options[:user]      = ENV['KITCHEN_USERNAME']
options[:port]      = ENV['KITCHEN_PORT']
options[:keys]      = ENV['KITCHEN_SSH_KEY']

set :host,        options[:host_name]
set :ssh_options, options
set :env, :LANG => 'C', :LC_ALL => 'C'
```

Add your sample tests to yourserverspectestfilename_spec.rb
```bash
require 'spec_helper'
describe service('ssh') do
  it { should be_running }
end
```

Add the below lines to .kitchen.yml
```bash
verifier:
  name: shell
  command: rspec -c -f d -I serverspec serverspec/operating_system_spec.rb
```
Set the environment varables for SSH connection for spec helper
```bash
export KITCHEN_HOSTNAME=44.55.66.77
export KITCHEN_USERNAME=ubuntu
export KITCHEN_PORT=22
export KITCHEN_SSH_KEY=keyname.pem
```

Run the following commands to create the infrastrucre with terraform and run the tests.
```bash
kitchen converge
kitchen verify
```

Your tests will be verified at last.

