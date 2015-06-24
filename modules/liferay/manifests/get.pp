class liferay::get(
  $version,
  $liferay_zip_filename,
  $zip_file_location,
  ) {


  $webapp_url        = "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/${version}/${liferay_zip_filename}"

  package {"wget":
    name   => "wget",
    ensure => present,
  }

  file {"zip-file-location":
    path   => "${zip_file_location}",
    ensure => "directory",
  }

  exec {"get-liferay":
    command => "wget ${webapp_url} -O ${zip_file_location}/${liferay_zip_filename}",
    cwd     => "/home/vagrant",
    path    => ["/usr/bin", "/bin"],
    require => [Package["wget"], File["zip-file-location"]],
    timeout => 1200,
    creates => "${zip_file_location}/${liferay_zip_filename}"
  }
  
}