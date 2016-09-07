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
    $liferay_db,
    $mail_server_port     = "",
    $liferay_dev,
    $external_tools,
  ) {

  $module_files_location = "/etc/puppet/modules/liferay/files"

  #Prepararation tasks  
  util::get { 'liferay' :
    base_url             => "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal",
    version              => $version,
    zip_filename         => $liferay_zip_filename,
    zip_file_location    => $module_files_location,
  }

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
    mail_server_port      => $mail_server_port,
    liferay_dev           => $liferay_dev,
    external_tools        => $external_tools,
    require               => Util::Get["liferay"],
  }

  

  
}