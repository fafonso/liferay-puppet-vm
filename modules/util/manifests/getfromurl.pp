define util::getfromurl(
  $url,
  $file_name,
  $file_location,
  ) {

  
  file {"${title}-file-location":
    path   => "${file_location}",
    ensure => "directory",
  } ->

  exec {"${title}-get":
    command => "wget \"${url}\" -O ${file_location}/${file_name}",
    cwd     => "/home/vagrant",
    path    => ["/usr/bin", "/bin"],
    timeout => 1200,
    creates => "${file_location}/${file_name}"
  }
  
}