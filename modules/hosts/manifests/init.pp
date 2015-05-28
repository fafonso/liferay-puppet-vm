class hosts {
  host { "${hostname}":
    ip => "127.0.0.1",
  }
}