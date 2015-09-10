class aptsetup {
  
	class { 'apt':
		update => {
		  frequency => 'daily',
		}
	} ->

	#Add required repo
	apt::ppa { 'ppa:webupd8team/java': } ->

	Exec['apt_update'] -> 
	
	#Apply apt update before any package
	Package <||>

}