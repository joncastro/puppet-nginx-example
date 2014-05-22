puppet-nginx-example
====================

This is an example of automating a nginx server with a simple site. For this purpose, vagrant and puppet tools have been chosen

## Requirements

- [Vagrant](http://downloads.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Usage

```
git clone https://github.com/joncastro/puppet-nginx-example
cd puppet-nginx-example
vagrant up
```
After executing above commands, just open an explorer with following link http://localhost:8000 and index.html will be server automatically

## Considerations

The vm is created with two networks, one in NAT mode and the other in host-only. The host-only network uses 192.168.222.45 ip, if this ip collision with your network just change the parameter config.vm.network in Vagrantfile.

Web page is accesible in the following two urls

-  http://localhost:8000  because 8000 host port is forwarded to 8000 guest host (See config.vm.forward_port param in Vagrantfile )
-  http://[host-only-ip]:8000  , in this case we are accessing directly to the server from the host

The site is serving the content from http directory in the host. This directory is mounted in /sites/site-example nginx server using VirtualBox share directories.

The nginx.conf configuration file is located in modules/nginx/files/nginx.conf. A standard configuration is set and it can be freely customize. By default is serving in 8000 port.

## Following boxes has been tested

ubuntu-server-12042-x64-vbox4210 box is used by default. To use a different box just comment current box and uncomment the desired one. Box is defined by the variables config.vm.box and config.vm.box_url in Vagrantfile.

<table>
<tr><th>Name</th><th>Url</th></tr>
<tr><td>centos-65-x64-virtualbox-puppet</td><td>http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box</td></tr>
<tr><td>debian-607-x64-vbox4210</td><td>http://puppet-vagrant-boxes.puppetlabs.com/debian-607-x64-vbox4210.box</td></tr>
<tr><td>debian-70rc1-x64-vbox4210</td><td>http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box</td></tr>
<tr><td>debian-73-x64-virtualbox-puppet</td><td>http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box</td></tr>
<tr><td>fedora-18-x64-vbox4210</td><td>http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box</td></tr>
<tr><td>ubuntu-server-12042-x64-vbox4210</td><td>http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box</td></tr>
</table>

If more boxes are willing to be supported minor adjustment could be required in puppet nginx-site.pp file

## A bit more detail of insides

When vagrant up is executed, it creates a new vm based on the configured box, mount http directory as a virtualbox share folder and execute puppet module in the vm. The puppet module ensure all the requirements to have an stable and consistent nginx server with a simple site. It ensures users, files, services, packages, configurations and others dependencies are configured properly. To make all those components consistent there are dependencies between the different them. For example, service nginx cannot start unless the package is installed.


## Questions

1. **Describe the most difficult/painful hurdle you had to overcome in implementing your solution.**<br/>
I wanted to support most of the puppet-vagrant-boxes flavors (Ubuntu, Debian, Fedora and Centos) and it took me some time to detect the differences between install nginx properly in those flavors. For example, Centos requires Epel repository to make nginx package available through yum, or Fedora requires stopping the firewall because it blocks 8000 port. So, it was a little painful to test and tune Puppet module to consider all these cases.

2. **Describe which puppet related concept you think is the hardest for new users to grasp.**<br/>
Understanding correctly resource abstraction probably is the first difficulty and also the key to success in Puppet. Once, you got clear how files, users, packages, services, ... are just treated as a simple resources that you could combine to build a desired state of a system then you understand how easily is to automate it.

3. **Please comment on the concept embodied by the second requirement of the solution(ii)**<br/>
Installing nginx server serving a simple html requires configuring many dependencies. For example, we must tune nginx.conf file, this file contains the unix users to run the service and that user must exists. So, in order to have nginx running with a simple site configuration we must ensure the state of many pre-requisites like firewall, users, configuration files, service status and so. Puppet gives us the ability to ensure that desire state just describing how we want to configure all these resources avoiding failures.<br/>
On the other side, Puppet checks periodically if the state is the expected one. If not, it modifies the resource again to the one that we defined. For example, nginx package is only installed if it doesn’t exist, or nginx is started if it is stopped. So, the full state is checked and in case everything is as expected, no action is required. If some resources are not correct they will be recovered taking into account their dependencies.<br/>
Notice: my exercise was based on vagrant and puppet masterless. If we want to force to check the desired state again we have just need to execute “vagrant provision”. In an environment with a Puppet master each node will check its state periodically.

4. **Where did you go to find information to help you in the build process?**<br/>
I’ve mainly used following documentation<br/>
Puppet Type Reference to check the parameters<br/>
http://docs.puppetlabs.com/references/latest/type.html <br/>
Vagrant Puppet Provisioner <br/>
http://docs.vagrantup.com/v2/provisioning/puppet_apply.html <br/>
I’ve reviewed a couple of vagrant and puppet examples <br/>
https://github.com/patrickdlee/vagrant-examples <br/>
I’ve reviewed how nginx is installed <br/>
http://www.cyberciti.biz/faq/install-nginx-centos-rhel-6-server-rpm-using-yum-command/ <br/>

5. **In a couple paragraphs explain what automation means to you and why it is important to an organization's infrastructure design strategy.**<br/>
Automation is the ability to reduce any human interaction in order to improve performance, accuracy, quality, and stability of a system. In the context of IT infrastructures there are many dependencies, like servers, operating systems, networking, storage, packages, services, users, application configurations, … and it is required to set all those dependencies in a certain state in order to have an stable system that meets users demands. So, automation is a key piece that gives us the ability to automate the process of setting a complete IT infrastructure based on our definition.<br/>
IT infrastructures are constantly evolving; they are continuously requiring new services, new servers, new software versions, scaling, ... Through automation we are able to minimize the time of delivering those changes into the infrastructure and at the same time we are able to keep consistency, reduce failures and prevent errors.
