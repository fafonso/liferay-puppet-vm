# Liferay VM Setup #

Project for ramp up a VM running Liferay from scratch using [Puppet](https://puppetlabs.com/) and [Vagrant](https://www.vagrantup.com/).

Disclaimer: This setup is not prepared/tuned for production environments and its usage for that propose is not recommended. 

### Usage ###

#### Prerequisites ####

* [Vagrant](http://docs.vagrantup.com/v2/getting-started/index.html) 
* [VirtualBox](https://www.virtualbox.org/)
* [Ubuntu trusty64 - Vagrant box](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)

#### Default usage (Liferay 7.1 CE GA1) ####

1. Open file "/manifests/default.pp"
2. Adjust the initial parameters for your case (top of the file)
3. Go to the terminal and execute "vagrant up" on the project root directory

```
Master branch is using Liferay 7.1. If you need Liferay 6.2 or 7.0 versions, please have a look on liferay-6.2.x or liferay-7.0.x branches.


```

#### Other Liferay distribution (Tomcat bundle) ####

1. Open file "/manifests/default.pp"
2. Copy the Liferay distribution archive to "/modules/liferay/files" 
3. Adjust the initial parameters for your case (top of the file)
4. Uncomment Liferay archive specific parameters and ensure that they are aligned with your case
5. Go to the terminal and execute "vagrant up" on the project root directory

### VM Configuration ###

#### Hardware ####

* OS: [Ubuntu](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) - Official Ubuntu Server 14.04 LTS (Trusty Tahr) builds
* By default Vagrant will try to compute the best resources configuration for you machine
* If that is not possible (Windows machines), it will apply the following configuration:
	* CPU: 4
	* RAM: 4096 (can be set to 3072 for single instance usage) 
* Changes can be done adjusting vb.memory and vb.cpus parameters in Vagrantfile


#### Groups #####

* www

#### Users #####

* liferay (www)

#### NTP & Timezone #####

* [NTP Module](https://forge.puppetlabs.com/puppetlabs/ntp)
* [Timezone Module](https://forge.puppetlabs.com/saz/timezone) (default to "Europe/Dublin")

#### Java (OracleJDK or OpenJDK) #####

* Version: OracleJDK 8 (default) or OpenJDK 8
* [Java Module](https://forge.puppetlabs.com/puppetlabs/java)
* Remote jmx configured on ports 9090 and 9091 with credential controlRole:liferay

#### Database (MySQL or PostgreSQL) #####

* [MySQL Module](https://forge.puppetlabs.com/puppetlabs/mysql) (Default)
* [PostgreSQL Module](https://forge.puppetlabs.com/puppetlabs/postgresql)
* liferay user
* lportal database
* Accessed only through localhost interface

#### Liferay #####

* Default usage will download Liferay 7.1 CE GA1 - bundled with Tomcat (9.0.6)
* Configured to access lportal database
* Configured to use <VAGRANT_SHARED_FOLDER>/liferay/deploy for deployments
* <VAGRANT_SHARED_FOLDER>/liferay/portal-ext.properties available for configurations 
* Configures tomcat as an unix service
* Use default port 8080 for http
* Development mode (optional) 
	* Will import portal-developer.properties file

#### HTTP Server (Optional) ####

* By default, none is used
* Apache 2.4
	* Configured with http proxy from port 80 to 8080
	* Uses mod-jk
	* Not configured to serve static content
	* Configured with compression (mod_deflate)
* NginX
	* Configured with http proxy from port 80 to 8080
	* Using HTTP instead of AJP
	* Not configured to serve static content

#### Email Server (Optional) #####

* Configures Liferay to use [Mailcatcher](http://mailcatcher.me/) as dummy email server
* [Web interface](http://localhost:11080) available to see all sent emails

```
There is a known issue with Mailcatcher related to Ruby 1.9 and Mailcatcher dependencies. 
As a workaround, it will give a Vagrant/puppet error during the VM creation but it will work. 
Please ensure that mailcatcher service is up and running. If not, please start the service manually "sudo service mailcatcher start". 


```

#### External Services (Optional) #####

* Will install and configure the following external services
	* [ImageMagicK](http://www.imagemagick.org/script/index.php) - Improve PDF and Images previews;
	* [OpenOffice / LibreOffice](https://www.libreoffice.org/download/libreoffice-fresh/) - Add previews and conversions for OpenDocument/MS Office files;
	* [Xuggler](http://www.xuggle.com/xuggler/) - Add audio and video previews.

#### IPTables (VM Local ports) #####

* Optional - Disabled by default
* [Firewall Module](https://forge.puppetlabs.com/puppetlabs/firewall)
* 22 ssh
* 80, 443 http server
* 8080, 8000 tomcat
* 9090, 9091 jmx
* 1080 Mailcatcher web interface (Optional)

#### VM Exposed Ports #####

* host: 1080, guest: 80    (Http server)
* host: 18080, guest: 8080 (Tomcat - Liferay)
* host: 18000, guest: 8000 (Tomcat debug - Liferay)
* host: 19090, guest: 9090 (jmx)
* host: 19091, guest: 9091 (jmx)
* host: 11080, guest: 1080 (Mailcatcher)

### Contribution guidelines ###

Feedback, contributions and improvements are welcome. Feel free to contact me.

### Special Thanks ###

Special thanks to Thiago Moreira for his valuable input to this project at earlier stage.