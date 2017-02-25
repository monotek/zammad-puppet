# class zammad::install
class zammad::install {

  file {
    $::repo_file:
      ensure  => file,
      path    => $::repo_file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Exec['repo-key-install'],
      content => template('zammad/repo.erb');
    $::webserver_config:
      ensure  => file,
      require => Package[ $::package_webserver ],
      path    => $::webserver_config,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template("zammad/${::webserver_template}");
  }

  exec {
    'repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $::repo_file ],
      refreshonly => true,
      subscribe   => File[ $::repo_file ],
      command     => $::repo_key_command;
    'es-plugin-install':
      path    => '/usr/bin/:/bin/:sbin/',
      require => Package[ $::package_elasticsearch ],
      creates => '/usr/share/elasticsearch/plugins/mapper-attachments',
      command => $::es_plugin_install_command;
    'es-config-command'
      path    => '/usr/bin/:/bin/:sbin/',
      require => Service[ $::service_zammad ],
      notify  => Exec[ 'es_index_create_command' ],
      command => $::es_config_command;
    'es-index-create-command'
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Exec[ 'es-config-command' ],
      refreshonly => true,
      command     => $::es_index_create_command;
  }

  package {
    $::package_database:
      ensure  => $::package_ensure;
    $::package_webserver:
      ensure  => $::package_ensure;
    $::package_elasticsearch:
      ensure  => $::package_ensure;
    'zammad':
      ensure  => $::package_ensure,
      notify  => Exec[ 'es-config-command' ],
      require => [ File[ $::repo_file ], Service[ $::service_database, $::service_elasticsearch, $::service_webserver ] ];
  }

  service {
    $::service_database:
      ensure  => running,
      require => Package[ $::package_database ];
    $::service_elasticsearch:
      ensure  => running;
      require => Exec['es-plugin-install'];
    $::service_webserver:
      ensure  => running;
      require => File[ $::webserver_config ];
    $::service_zammad:
      ensure  => running,
      require => [ Package[ $::package_zammad ], Service[ $::service_database, $::service_elasticsearch, $::service_webserver ] ];
  }

}
