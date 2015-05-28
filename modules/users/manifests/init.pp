class users(
    $liferay_user,
    $liferay_user_group = "www",
    $liferay_user_home,
  ) {
  

  user { "$liferay_user":
    ensure     => present,
    home       => $liferay_user_home,
    groups     => $liferay_user_group,
    uid        => "510",
    require    => Class["groups"]
  }




}