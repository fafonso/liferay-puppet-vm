class externalservices::xuggler (
    $tomcat_home,
  ){

  # Download Xuggler jar from Liferay CDN
  # https://files.liferay.com/mirrors/xuggle.googlecode.com/svn/trunk/repo/share/java/xuggle/xuggle-xuggler/5.4/xuggle-xuggler-arch-x86_64-pc-linux-gnu.jar
  # And send it to Liferay WEB-INF/lib

  util::getfromurl { 'xuggler' :
    url           => "https://files.liferay.com/mirrors/xuggle.googlecode.com/svn/trunk/repo/share/java/xuggle/xuggle-xuggler/5.4/xuggle-xuggler-arch-x86_64-pc-linux-gnu.jar",
    file_name     => "xuggle-xuggler-arch-x86_64-pc-linux-gnu.jar",
    file_location => "${$tomcat_home}/webapps/ROOT/WEB-INF/lib",
  }
  
}