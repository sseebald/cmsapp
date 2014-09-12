class dotnetcms::staging {

  # Set up the staging class, declaring the appropriate staging directory
  # dependent on operatingsystem.
  case $::osfamily {
    default: {
      class { '::staging':
        path  => '/var/staging',
      }
    }
    'windows': {
      class { '::staging':
        path  => 'C:/staging',
      }
    }
  }

}
