Vagrant::Config.run do |config|

  # Set base box

  config.vm.box = "ubuntu-server-12042-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  #config.vm.box = "debian-607-x64-vbox4210"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-607-x64-vbox4210.box"

  #config.vm.box = "fedora-18-x64-vbox4210"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box"

  #config.vm.box = "centos-65-x64-virtualbox-puppet"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"

  #config.vm.box = "debian-70rc1-x64-vbox4210"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

  #config.vm.box = "debian-73-x64-virtualbox-puppet"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box"


  # Forward the port to make accessible the web site from the host (http://localhost:8000)
  config.vm.forward_port 8000, 8000

  # Optional: set a host only network.
  # This is usefull if we want to acess directly from the host to the vm using guest ip address, http://192.168.222.45:8000
  config.vm.network :hostonly, "192.168.222.45"

  # Create a share folder to server pages by the site located in the host and mounted in the guest
  config.vm.share_folder "site-example", "/sites/site-example", "http"

  # Execute puppet automation to automate nginx including the new site
  config.vm.provision :puppet, :module_path => "modules" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "nginx-site.pp"
  end

end
