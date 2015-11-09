class apm::dynatrace(
	  $install_path,
    $liferay_cluster,
    $java_distribution,
  ) {

    if ($liferay_cluster or $java_distribution != "oracle") {
      fail('For simplicity, Dynatrace can only be used with a Liferay single node configuration and with oracle Java')
    }
    # NOTE: This module will NOT wire the agents to Liferay

    require javad::oracle

    ################### EXECUTION

    $module_files_location            = "/etc/puppet/modules/apm/files"

    $dynatrace_agent_download_url     = "http://www.dynatrace.com/clientservices/agent?version=6.2.0.1238&os=linux&arch=x86&techtype=java"
    $dynatrace_agent_jar_name         = "dynatrace-agent-6.2.0.1238-unix.jar"
    $dynatrace_agent_install_path     = "${install_path}/dynatrace-jvmagent-6.2.0"

    $dynatrace_server_download_url    = "http://d1iai81hh60v12.cloudfront.net/dynatrace-6.2.0.1239-linux-x64.jar"
    $dynatrace_server_jar_name        = "dynatrace-6.2.0.1239-linux-x64.jar"
    $dynatrace_install_path           = "${install_path}/dynatrace-6.2.0"
    $dynatrace_server_service_name    = "dynaTraceServer"
    $dynatrace_collector_service_name = "dynaTraceCollector"

    $installation_user                = "vagrant"
    $installation_group               = "vagrant"
    $max_open_files                   = "2048"

    #Increase the ulimit for vagrant user
    #Dynatrace requires at least 2048
    class { 'ulimit':
      purge => false,
    } ->

    ulimit::rule {'dynatrace-ulimit':
      ulimit_domain => $installation_user,
      ulimit_type   => 'soft',
      ulimit_item   => 'nofile',
      ulimit_value  => '2048';
    }

    ################### JVM AGENT

    #Ensure that we have the download root folder 
    file {"${module_files_location}":
      ensure => "directory",
      owner  => $installation_user,
      group  => $installation_group,
      mode   => 775,
    } -> 

    # Download Agents package for the Linux platform (without webserver agent)
    util::getfromurl { 'dynatrace-agent' :
      url           => $dynatrace_agent_download_url,
      file_name     => $dynatrace_agent_jar_name,
      file_location => "${module_files_location}/agent",
    } ->

    #Ensure that we have the installation folder
    file {"${dynatrace_agent_install_path}":
      ensure => "directory",
      owner  => $installation_user,
      group  => $installation_group,
      mode   => 775,
    } -> 

    #Install Dynatrace JVM Agent
    exec {"install-dynatrace-jvm-agent":
      command   => "java -jar ${dynatrace_agent_jar_name} -t ${dynatrace_agent_install_path} -y",
      cwd       => "${module_files_location}/agent",
      path      => ["/usr/bin", "/bin"],
      timeout   => 1200,
      user      => $installation_user,
    }

    # Doublecheck if we need to change the ownership of dynatrace files


    ################### SERVER AND COLLECTOR

    #Download Dynatrace bundle (server and collector)
    util::getfromurl { 'dynatrace-server' :
      url           => $dynatrace_server_download_url,
      file_name     => $dynatrace_server_jar_name,
      file_location => "${module_files_location}/server",
    } ->

    #Ensure that we have the installation folder
    file {"${dynatrace_install_path}":
      ensure => "directory",
      owner  => $installation_user,
      group  => $installation_group,
      mode   => 775,
    } ->

    #Install Dynatrace Server and collector
    exec {"install-dynatrace-server":
      command   => "java -jar ${dynatrace_server_jar_name} -t ${dynatrace_install_path} -y",
      cwd       => "${module_files_location}/server",
      path      => ["/usr/bin", "/bin"],
      timeout   => 1200,
      user      => $installation_user,
    } -> 

    # Doublecheck if we need to change the ownership of dynatrace files

    file { "service-dynatrace-server":
      name       => "/etc/init.d/${dynatrace_server_service_name}",
      ensure     => present,
      source    => "${dynatrace_install_path}/init.d/${dynatrace_server_service_name}",
      owner      => "root",
      group      => "root",
      mode       => 0755,
    } -> 



    file { "service-dynatrace-collector":
      name       => "/etc/init.d/${dynatrace_collector_service_name}",
      ensure     => present,
      source    => "${dynatrace_install_path}/init.d/${dynatrace_collector_service_name}",
      owner      => "root",
      group      => "root",
      mode       => 0755,
    } -> 


    service { "${dynatrace_server_service_name}":
      ensure    => "running",
      enable    => true,
      hasstatus => false,
    } ->

    service { "${dynatrace_collector_service_name}":
      ensure    => "running",
      enable    => true,
      hasstatus => false,
    }


}