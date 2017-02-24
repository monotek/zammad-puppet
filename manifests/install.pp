# class zammad::install
class zammad::install {

  file {
    $repo_file:
        ensure  => file,
        path    => $repo_file,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('zammad/repo.erb');
  }

  exec {
    'repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $repo_file ],
      refreshonly => true,
      command     => $repo_key_command;
  }

  package {
    $package_database:
      ensure  => installed;
    $package_webserver:
      ensure  => installed;
    $package_elasticsearch:
      ensure  => installed;
    'zammad':
      ensure  => $package_ensure,
      require => [
        Exec['repo-key-install'],
        Package[ $package_database, $package_webserver, $package_elasticsearch ]
      ];
  }

  service {
    $service_database:
      ensure  => running;
    $service_elasticsearch:
      ensure  => running;
    $service_webserver:
      ensure  => running;
    $service_zammad:
      ensure  => running,
      require => Service[ $service_database, $service_elasticsearch, $service_webserver ];
  }

}
