# Liferay VM Setup #

Project for ramp up a VM running Liferay from scratch using [Puppet](https://puppetlabs.com/) and [Vagrant](https://www.vagrantup.com/).

Disclaimer: This setup is not prepared/tuned for production environments and its usage for that propose is not recommended. 

### Usage ###

#### Prerequisites ####

* [Vagrant](http://docs.vagrantup.com/v2/getting-started/index.html) 
* [VirtualBox](https://www.virtualbox.org/)
* [Ubuntu trusty64 - Vagrant box](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)

#### Default usage (Liferay 6.2 CE GA4) ####

1. Open file "/manifests/default.pp"
2. Adjust the initial parameters for your case (top of the file)
3. Go to the terminal and execute "vagrant up" on the project root directory

#### Cluster configuration (Liferay 6.2 CE GA4 / 2 nodes) ####

1. Open file "/manifests/default.pp"
2. Uncomment cluster related configurations
3. Adjust the initial parameters for your case (top of the file)
4. Go to the terminal and execute "vagrant up" on the project root directory

```
The second node must be manually started after the process is complete.
Example: sudo service tomcat8081 start


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
* CPU: 2
* RAM: 4096 (can be set to 3072 for single instance usage)

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
* Configures tomcat as an unix service
* Use default port 8080 for http

#### Liferay (Cluster) #####

* Default usage will download Liferay 6.2 CE GA4 - bundled with tomcat
* Configured to access lportal database for both nodes
* Configured to use <VAGRANT_SHARED_FOLDER>/liferay/deploy/nodeX for deployments
* Configures tomcat and tomcat8081 as unix service
* Set /opt/liferay/data/document_library as document library for both nodes, using Liferay AdvancedFileSystemStore
* Http ports configured are 8080 for node1 and 8081 for node2
* Uses the default Liferay cluster configuration (Multicast and RMI)

#### Apache2 #####

* Configured with http proxy from port 80 to 8080
* Uses mod-jk
* Not configured to serve static content

#### Apache2 (Cluster) #####

* Configured with http proxy from port 80 to 8080/8081
* Sticky sessions
* Load balancing configured with "by request" approach
* Uses proxy, proxy_ajp, proxy_balancer, lbmethod_byrequest and slotmem_shm modules
* Not configured to serve static content

#### IPTables (VM Local ports) #####

* [Firewall Module](https://forge.puppetlabs.com/puppetlabs/firewall)
* 22 ssh
* 80, 443 apache
* 8080, 8000 tomcat
* 9090, 9091 jmx
* 8081 tomcat2 (Cluster only)
* 23301-23351 Multicast (Cluster only)

#### VM Exposed Ports #####

* host: 1080, guest: 80
* host: 18080, guest: 8080
* host: 18081, guest: 8081
* host: 18000, guest: 8000
* host: 19090, guest: 9090
* host: 19091, guest: 9091

### Contribution guidelines ###

Feedback, contributions and improvements are welcome. Feel free to contact me.