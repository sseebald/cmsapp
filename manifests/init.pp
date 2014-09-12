# Class to deploy simple .NET application
class cmsapp {

  include profile::staging

  staging::file { 'CMS4.06.zip':
    target => 'C:\staging\CMS4.06.zip',
    source => 'puppet:///modules/cmsapp/CMS4.06.zip',
  }

  exec { 'extract_cms4':
    path      => 'C:\Program Files (x86)\7-Zip',
    command   => '7z.exe x C:\staging\CMS4.06.zip -oC:\cms4app',
    creates   => 'C:\cms4app',
    subscribe => Staging::File['CMS4.06.zip'],
  }

  reboot { 'after iis is done': 
    subscribe => Exec["extract_cms4"],
  }

  iis::manage_app_pool { 'CMS4':
    ensure                  => present,
    managed_pipeline_mode   => 'Integrated',
    managed_runtime_version => 'v4.0',
    enable_32_bit           => true,
  }

  iis::manage_site {'CMS4':
    ensure     => present,
    site_path  => 'C:\cms4app\CMS',
    app_pool   => 'CMS4',
    port       => '80',
    ip_address => '*',
  }

  iis::manage_site_state { 'CMS4':
    ensure    => running,
    site_name => 'CMS4',
  }

}
