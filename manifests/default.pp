#################################
##       Configurations        ##
#################################

#DB config
$db_user              = "liferay"
$db_password          = "D3P4ssw0rd"
$db_name              = "lportal"

#To ensure the clock is synchronized
$timzone              = "Europe/Dublin"

#Liferay configuration
$liferay_user         = "liferay"
$install_path         = "/opt/liferay"

#Install Liferay from local archive
#$liferay_zip_filename = "liferay-portal-tomcat-6.2-ee-sp11-20150407182402908.zip"
#Liferay folder name inside zip archive
#$liferay_folder       = "liferay-portal-6.2-ee-sp11"

#Cluster configuration
#$liferay_cluster      = true

#Tomcat info (in a cluster configuration, each of the nodes will get this JVM memory parameters)
#$xmx                  = "1024"
#$permsize             = "256"

#################################
##      Environment setup      ##
#################################

include hosts
include groups

class { 'users' :
	liferay_user => $liferay_user,
	liferay_user_home => $install_path,
}

#Configuring ntp module
include '::ntp'

#Setting the proper timezone
class { 'timezone':
    timezone => $timzone,
}

#Updating APT and adding ppa to get Oracle Java
package { 'python-software-properties':
	ensure => present,
}

class { 'apt':
  update => {
    frequency => 'daily',
  },
  ppas        => {
  	javappa   => {
  		name  => 'ppa:webupd8team/java'
  	},
  },
  require      => Package['python-software-properties']
}

#Get and install Oracle Java
exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
 
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
}

class { 'java':
  distribution => 'oracle-jdk',
  package      => 'oracle-java7-installer',
  require      => [
  	Class['apt'],
  	Exec['set-licence-selected'], 
  	Exec['set-licence-seen'],
  ]
}

#Setup jmx access
class {'jmx' :
  require  => Class['java']
}

#Setup MySQL with the required DB
$override_options = {
  'mysqld' => {
    'symbolic-links' => '0',
  }
}

class { '::mysql::server':
  root_password           => $db_password,
  remove_default_accounts => true,
  override_options        => $override_options,
  restart                 => true,
}

mysql::db { $db_name :
  user     => $db_user,
  password => $db_password,
  host     => 'localhost',
  charset  => 'utf8',
  collate  => 'utf8_general_ci',
}

#Setup Liferay
class { 'liferay' :
  db_user              => $db_user,
  db_password          => $db_password,
  db_name              => $db_name,
  install_path         => $install_path, 
  liferay_user         => $liferay_user,
  liferay_cluster      => $liferay_cluster,
  liferay_zip_filename => $liferay_zip_filename,
  liferay_folder       => $liferay_folder,
  xmx                  => $xmx,
  permsize             => $permsize,
  require              => [
    Class['java'], 
    Class['::mysql::server'],
    Class['users'],
  ]
}

#Setup Apache2
class {'apache' :
  cluster  => $liferay_cluster,
  require  => [
  	Class['apt'], 
  	Class['liferay'],
  ],
}

#Setup firewall
resources { "firewall":
  purge => true
}

Firewall {
  before  => Class['iptables::post'],
  require => Class['iptables::pre'],
}

class { ['iptables::pre', 'iptables::post']: }

class { 'firewall': 
	require => [Class['liferay'], Class['apache']],
}






