define util::get(
  $base_url,
  $version,
  $zip_filename,
  $zip_file_location,
  ) {

  $webapp_url        = "${$base_url}/${version}/${zip_filename}"

  file {"${title}-zip-file-location":
    path   => "${zip_file_location}",
    ensure => "directory",
  }

  exec {"${title}-get":
    command => "wget ${webapp_url} -O ${zip_file_location}/${zip_filename}",
    cwd     => "/home/vagrant",
    path    => ["/usr/bin", "/bin"],
    require => File["${title}-zip-file-location"],
    timeout => 1200,
    creates => "${zip_file_location}/${zip_filename}"
  }
  
}