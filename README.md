# Liferay VM Setup #

Project for ramp up a VM running Liferay from scratch using [Puppet](https://puppetlabs.com/) and [Vagrant](https://www.vagrantup.com/).

Disclaimer: This setup is not prepared/tuned for production environments and its usage for that propose is not recommended. 

### Usage ###

#### Prerequisites ####

* Vagrant installed
* [Ubuntu trusty64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)

#### Default usage (Liferay 6.2 CE GA4) ####

1. Open file "/manifests/default.pp"
2. Adjust the initial parameters for your case (top of the file)
3. Go to the terminal and execute "vagrant up" on the project root directory

#### Other Liferay distribution (Tomcat bundle) ####

1. Open file "/manifests/default.pp"
2. Copy the Liferay distribution archive to "/modules/liferay/files" 
3. Adjust the initial parameters for your case (top of the file)
4. Uncomment Liferay archive specific parameters and ensure that they are aligned with your case
5. Go to the terminal and execute "vagrant up" on the project root directory

### VM Configuration ###

#### Hardware ####

* OS: [Ubuntu](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) - Official Ubuntu Server 14.04 LTS (Trusty Tahr) builds
* CPU: 2
* RAM: 3072

#### Groups #####

* www

#### Users #####

* liferay (www)

#### NTP & Timezone #####

* [NTP Module](https://forge.puppetlabs.com/puppetlabs/ntp)
* [Timezone Module](https://forge.puppetlabs.com/saz/timezone) (default to "Europe/Dublin")

#### Java #####

* Version: Oracle 1.7
* [Java Module](https://forge.puppetlabs.com/puppetlabs/java)
* Remote jmx configured on ports 9090 and 9091 with credential controlRole:liferay

#### MySQL #####

* [MySQL Module](https://forge.puppetlabs.com/puppetlabs/mysql)
* liferay user
* lportal database
* Accessed only through localhost interface

#### Liferay #####

* Default usage will download Liferay 6.2 CE GA4 - bundled with tomcat
* Configured to access lportal database
* Configured to use <VAGRANT_SHARED_FOLDER>/liferay/deploy for deployments
* Configures Tomcat as an unix service

#### Apache2 #####

* Configured with http proxy from port 80 to 8080
* Uses mod-jk
* Not configured to serve static content

#### IPTables (VM Local ports) #####

* [Firewall Module](https://forge.puppetlabs.com/puppetlabs/firewall)
* 22 ssh
* 80, 443 apache
* 8080, 8000 tomcat
* 9090, 9091 jmx

#### VM Exposed Ports #####

* host: 1080, guest: 80
* host: 18080, guest: 8080
* host: 18000, guest: 8000
* host: 19090, guest: 9090
* host: 19091, guest: 9091

### Contribution guidelines ###

Contributions and improvements are welcomed. Fell free to send Pull Requests. 

Filipe Afonso
