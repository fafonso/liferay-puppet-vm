# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network :forwarded_port, host: 1080, guest: 80
  #config.vm.network :forwarded_port, host: 13306, guest: 3306
  config.vm.network :forwarded_port, host: 18080, guest: 8080
  config.vm.network :forwarded_port, host: 18000, guest: 8000
  config.vm.network :forwarded_port, host: 18081, guest: 8081
  config.vm.network :forwarded_port, host: 19090, guest: 9090
  config.vm.network :forwarded_port, host: 19091, guest: 9091


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :private_network, ip: "192.168.10.01"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=777', 'fmode=777']


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider "virtualbox" do |vb|

    # Assure that the guest machine clock is synced with the host every 10s
    #vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
  
     # Customize the amount of memory on the VM:
     # vb.memory = "3072"
     vb.memory = "4096"
     vb.cpus = 2
     vb.name = "vagrant.liferay.com"
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  # config.vm.provision :puppet
  config.vm.provision :shell do |shell|
  shell.inline = "mkdir -p /etc/puppet/modules;
                  cp -r /vagrant/modules/* /etc/puppet/modules;
                  puppet module install puppetlabs-stdlib;
                  puppet module install puppetlabs-mysql;
                  puppet module install puppetlabs-java;
                  puppet module install puppetlabs-apt;
                  puppet module install saz-timezone;
                  puppet module install puppetlabs-ntp;
                  puppet module install puppetlabs-firewall"
  end

  #[Tomcat module]
  #puppet module install puppetlabs-stdlib;
  #puppet module install puppetlabs-tomcat

  #[Apache]
  #puppet module install puppetlabs-apache;

  config.vm.provision :puppet do |puppet|

    puppet.facter = {
      "fqdn" => "vagrant.liferay.com"
    }

    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
    #puppet.module_path = "modules"
    #puppet.options = "--hiera_config /vagrant/hiera.yaml --verbose --debug"
    puppet.options = "--hiera_config /vagrant/hiera.yaml"
  end

  

  # To avoid the Warning: Could not retrieve fact fqdn
  config.vm.hostname = "vagrant.liferay.com"
end
