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
