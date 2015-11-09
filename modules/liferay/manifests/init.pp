class liferay(
  $liferay_folder, 
  $tomcat_folder, 
  $version,
  $liferay_zip_filename,
  $liferay_vagrant_dir  = "/vagrant/liferay",
  $db_user,
  $db_password,
  $db_name,
  $xmx,
  $permsize,
  $install_path,
  $liferay_user,
  $liferay_group,
  $liferay_cluster      = false,
  $liferay_db,
  $solr_http_port       = "",
  $solr_distribution    = "",
  $mail_server_port     = "",
  $apm                  = "",
  ) {

  $module_files_location = "/etc/puppet/modules/liferay/files"

  #SOLR configuration depending on solr version
  if ($solr_http_port) {

    if ($solr_distribution in [ '3.5.0' ]) {
      # Preparing the Liferay SOLR3 plugin
      $solr_plugin_name = "solr3-web-6.2.0.1"

      # Set the file from the template with correct http port for SOLR
      file { "solr-spring":
        content    => template("liferay/solr3/solr-spring.xml.erb"),
        replace    => true,
        path       => "${module_files_location}/${solr_plugin_name}/WEB-INF/classes/META-INF/solr-spring.xml",
      } ->

      # Zip the folder
      exec {"zip-solr-liferay":
        command => "zip -r ${solr_plugin_name}.zip WEB-INF",
        cwd     => "${module_files_location}/${solr_plugin_name}",
        path    => ["/usr/bin", "/bin"],
        require => Package["zip"],
      } -> 

      file {"solr-war-directory":
        path   => "${module_files_location}/solr",
        ensure => "directory",
        owner  => $liferay_user,
        group  => $liferay_group,
        mode   => 775,
      } ->

      # Change from zip to war file
      exec {"war-solr-liferay":
        command => "mv ${solr_plugin_name}.zip ../solr/${solr_plugin_name}.war",
        cwd     => "${module_files_location}/${solr_plugin_name}",
        path    => ["/usr/bin", "/bin"],
      }

    } else {
      fail('THERE IS NO CONNECTOR CONFIGURED FOR THAT VERSION OF SOLR. PLEASE USE ONE OF THE FOLLOWING: 3.5.0')
    }

  }

  #Prepararation tasks  
  util::get { 'liferay' :
    base_url             => "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal",
  	version              => $version,
  	zip_filename         => $liferay_zip_filename,
  	zip_file_location    => $module_files_location,
  }

  if($liferay_cluster) {
    #Setup Liferay cluster with 2 nodes
    
    class { 'liferay::cluster' :
      db_user               => $db_user,
      db_password           => $db_password,
      db_name               => $db_name,
      install_path          => $install_path, 
      liferay_user          => $liferay_user,
      liferay_group         => $liferay_group,
      liferay_folder        => $liferay_folder, 
      tomcat_folder         => $tomcat_folder, 
      liferay_zip_filename  => $liferay_zip_filename,
      module_files_location => $module_files_location,
      liferay_vagrant_dir   => $liferay_vagrant_dir,
      xmx                   => $xmx,
      permsize              => $permsize,
      liferay_db            => $liferay_db,
      solr_distribution     => $solr_distribution,
      mail_server_port      => $mail_server_port,
      apm                   => $apm,
      require               => Util::Get["liferay"],
    }

  } else {
    #Setup Liferay single node
    liferay::single { 'single' :
      db_user               => $db_user,
      db_password           => $db_password,
      db_name               => $db_name,
      install_path          => $install_path, 
      liferay_user          => $liferay_user,
      liferay_group         => $liferay_group,
      liferay_folder        => $liferay_folder, 
      tomcat_folder         => $tomcat_folder, 
      liferay_zip_filename  => $liferay_zip_filename,
      module_files_location => $module_files_location,
      liferay_vagrant_dir   => $liferay_vagrant_dir,
      xmx                   => $xmx,
      permsize              => $permsize,
      liferay_db            => $liferay_db,
      solr_distribution     => $solr_distribution,
      mail_server_port      => $mail_server_port,
      apm                   => $apm,
      require               => Util::Get["liferay"],
    }

  }

  
}