# class zammad::install
class zammad::install {

  file {
    $::zammad::params::repo_file:
      ensure  => file,
      path    => $::zammad::params::repo_file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Exec['repo-key-install'],
      content => template("zammad/${::zammad::params::repo_template}");
    $::zammad::params::webserver_config:
      ensure  => file,
      require => Package[ $::zammad::params::package_webserver ],
      path    => $::zammad::params::webserver_config,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template("zammad/${::zammad::params::webserver_template}");
  }

  exec {
    'es-plugin-install':
      path    => '/usr/bin/:/bin/:sbin/',
      require => Package[ $::zammad::params::package_elasticsearch ],
      creates => '/usr/share/elasticsearch/plugins/mapper-attachments',
      command => $::zammad::params::es_plugin_install_command;
    'es-config-command':
      path    => '/usr/bin/:/bin/:sbin/',
      require => Service[ $::zammad::params::service_zammad ],
      notify  => Exec[ 'es-index-create-command' ],
      command => $::zammad::params::es_config_command;
    'es-index-create-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Exec[ 'es-config-command' ],
      refreshonly => true,
      command     => $::zammad::params::es_index_create_command;
    'repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $::zammad::params::repo_file ],
      refreshonly => true,
      command     => $::zammad::params::repo_key_command;
  }

  package {
    $::zammad::params::package_database:
      ensure  => $::zammad::params::package_ensure;
    $::zammad::params::package_webserver:
      ensure  => $::zammad::params::package_ensure;
    $::zammad::params::package_elasticsearch:
      ensure  => $::zammad::params::package_ensure;
    'zammad':
      ensure  => $::zammad::params::package_ensure,
      notify  => Exec[ 'es-config-command' ],
      require => [ Exec[ 'repo-key-install' ], Package[ $::zammad::params::service_database, $::zammad::params::service_elasticsearch, $::zammad::params::service_webserver ] ];
  }

  service {
    $::zammad::params::service_database:
      ensure  => running,
      require => Package[ $::zammad::params::package_database ];
    $::zammad::params::service_elasticsearch:
      ensure  => running,
      require => Exec['es-plugin-install'];
    $::zammad::params::service_webserver:
      ensure  => running,
      require => File[ $::zammad::params::webserver_config ];
    $::zammad::params::service_zammad:
      ensure  => running,
      require => [ Package[ $::zammad::params::package_zammad ], Package[ $::zammad::params::package_database, $::zammad::params::package_elasticsearch, $::zammad::params::package_webserver ] ];
  }

}
