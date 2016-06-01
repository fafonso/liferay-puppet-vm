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

  #Webserver
  config.vm.network :forwarded_port, host: 1080,  guest: 80

  #Tomcat - Liferay
  config.vm.network :forwarded_port, host: 18080, guest: 8080
  config.vm.network :forwarded_port, host: 18000, guest: 8000
  config.vm.network :forwarded_port, host: 18081, guest: 8081

  #SOLR
  config.vm.network :forwarded_port, host: 18180, guest: 8180
  
  #JMX
  config.vm.network :forwarded_port, host: 19090, guest: 9090
  config.vm.network :forwarded_port, host: 19091, guest: 9091
  
  #Mailcatcher
  config.vm.network :forwarded_port, host: 11080, guest: 1080

  #Dynatrace ports
  config.vm.network :forwarded_port, host: 12021, guest: 2021
  config.vm.network :forwarded_port, host: 18021, guest: 8021
  config.vm.network :forwarded_port, host: 19911, guest: 9911
  #config.vm.network :forwarded_port, host: 15432, guest: 5432
  #config.vm.network :forwarded_port, host: 13306, guest: 3306
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :private_network, ip: "192.168.10.10"

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
  
    # (Option 1) Customize the amount of memory on the VM:
    #vb.memory = "4096"
    #vb.cpus = 4
     
    # (Option 2) Configuration for Dynatrace
    #vb.memory = "6144"
    #vb.cpus = 4

    # (Option 3) RECOMMENDED APPROACH: Give VM 1/4 system memory & access to all cpu cores on the host
    host = RbConfig::CONFIG['host_os']

    if host =~ /darwin/
      vb.cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      vb.memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      vb.cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      vb.memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      vb.cpus = 4
      vb.memory = 4096
    end

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
                  puppet module install puppetlabs-stdlib --version 4.12.0;
                  puppet module install puppetlabs-apt --version 2.2.2;
                  puppet module install puppetlabs-mysql --version 3.7.0;
                  puppet module install puppetlabs-java --version 1.5.0;
                  puppet module install puppetlabs-postgresql --version 4.7.1;
                  puppet module install saz-timezone --version 3.3.0;
                  puppet module install puppetlabs-ntp --version 4.2.0;
                  puppet module install puppetlabs-firewall --version 1.8.1;
                  puppet module install puppetlabs-tomcat --version 1.5.0;
                  puppet module install arioch-ulimit --version 0.0.2"
  end


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

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    #config.cache.synced_folder_opts = {
      #type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      #mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #}
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

end
