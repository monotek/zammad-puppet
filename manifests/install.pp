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
    $webserver_config:
      ensure  => file,
      path    => $webserver_config,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('zammad/nginx.erb');
  }

  exec {
    'repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $repo_file ],
      refreshonly => true,
      command     => $repo_key_command;
    'es-plugin-install'
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package[ $package_elasticsearch ],
      creates     => '/usr/share/elasticsearch/plugins/mapper-attachments',
      command     => $es_plugin_install_command;
  }

  package {
    $package_database:
      ensure  => $package_ensure;
    $package_webserver:
      ensure  => $package_ensure;
    $package_elasticsearch:
      ensure  => $package_ensure;
    'zammad':
      ensure  => $package_ensure,
      require => [ Exec['repo-key-install'], Package[ $package_database, $package_webserver, $package_elasticsearch ]
      ];
  }

  service {
    $service_database:
      ensure  => running,
      require => Package[ $package_database ];
    $service_elasticsearch:
      ensure  => running;
      require => Exec['es-plugin-install'];
    $service_webserver:
      ensure  => running;
      require => [ Package[ $package_webserver ], File[$webserver_config] ];
    $service_zammad:
      ensure  => running,
      require => [ Package[ $package_zammad ], Service[ $service_database, $service_elasticsearch, $service_webserver ] ];
  }

}