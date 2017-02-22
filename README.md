Lionel Mark's SE Demo for HashiCorp
==================================

WElCOME to Lionel Marks' SE Demo. The demos are accessible via my github repository or by downloading a vagrant box. I've included easy to follow instructions below.

Github Repository: https://github.com/lvm76gh/SE-Lionel-Demo.git
Vagrant Box: lmarks/LionelBox

This Demo incorporates many of HashiCorps technologies. At it's core is Terraform, which is used in conjunction with the AWS provider to errect a 3-node cluster with Consul,Nomad & Vault pre-installed and configured using detected private IPs. 

The Demo scripts act as mini-applications that automatically parse the terraform artifacts for AWS public IPs and run basic HTTP/SSH requests against the varios services in this 3-node cluster. Each script is designed to be self-explanitory by invoking the command with no arguments. Basic arguments can be used to interact with the demo scripts to simplify and streamline how we interact with the 3-node cluster across the WAN. See below for further instructions and details.

Pre-requisites:
		o Download the below Vagrant Box 
		o Or use a development environment that has both Packer, Terraform & Git installed
		o If using personal development environment, grab git project http://github.com/lvm76gh/SE-Lionel-Demo.git 

Vagrant Demo: 
		o A pre-baked development environment with all the necessary tools for this demo are availbale as a Vagrant Box on Atlas
			- vagrant@precise64:~$ vagrant box add lmarks/LionelBox



Terraform Demo:
		o Edit the "consul.tf" file and add your AWS Access Key & Secret 
		o Launch following commands to initialize the build
			- vagrant@precise64:~$ terraform get
			- vagrant@precise64:~$ terraform apply
Redis Demo:
		o Launch script ./RedisDemo.sh - basic help is dislplayed
		o Arguments that can be run are {start|stop|status|discover}
			- vagrant@precise64:~$ RedisDemo.sh start 
			- vagrant@precise64:~$ RedisDemo.sh stop
			- vagrant@precise64:~$ RedisDemo.sh status 
			- vagrant@precise64:~$ RedisDemo.sh discover
Vault Demo:
		o Launch script ./VaultDemo.sh - basic help is dislplayed
		o Arguments that can be run are {init|unseal|auth|put|get}
			- vagrant@precise64:~$ VaultDemo.sh init 
			- vagrant@precise64:~$ VaultDemo.sh unseal
			- vagrant@precise64:~$ VaultDemo.sh put 
			- vagrant@precise64:~$ VaultDemo.sh get
Packer Demo:
		o Edit the "packerdemo.json" file and add your AWS Access Key & Secret 
		o Simple example to create AWS AMI using Packer
			- vagrant@precise64:~$ Packer packerdemo.json
