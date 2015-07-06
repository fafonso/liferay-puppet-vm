class users(
    $liferay_user,
    $liferay_group,
    $liferay_user_home,
  ) {
  

  user { "$liferay_user":
    ensure     => present,
    home       => $liferay_user_home,
    groups     => $liferay_group,
    uid        => "510",
    require    => Class["groups"]
  }




}