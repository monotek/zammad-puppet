# class zammad::install
class zammad::install {

  package { 'curl':
    ensure => installed;
  }

  file {
    $::zammad::es_repo_file:
      ensure  => file,
      path    => $::zammad::es_repo_file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Exec['es-repo-key-install'],
      content => template("zammad/${::zammad::es_repo_template}");
    $::zammad::webserver_config:
      ensure  => file,
      require => Package[ $::zammad::package_webserver ],
      path    => $::zammad::webserver_config,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Service[ $::zammad::webserver_service ],
      content => template("zammad/${::zammad::webserver_template}");
  }

  exec {
    'es-repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $::zammad::es_repo_file ],
      refreshonly => true,
      command     => $::zammad::es_repo_key_command;
    'es-plugin-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package[ $::zammad::package_elasticsearch ],
      creates     => '/usr/share/elasticsearch/plugins/mapper-attachments',
      notify      => Service[ $::zammad::service_elasticsearch ],
      refreshonly => true,
      command     => $::zammad::es_plugin_install_command;
    'es-url-config-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package[ $::zammad::package_zammad ],
      notify      => Exec[ 'es-index-create-command' ],
      refreshonly => true,
      command     => $::zammad::es_url_config_command;
    'es-index-config-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => [ Package[ $::zammad::package_zammad ], Exec['es-url-config-command'] ],
      notify      => Exec[ 'es-index-create-command' ],
      refreshonly => true,
      command     => "zammad run rails r \"Setting.set('es_index', Socket.gethostname + '_${zammad_user}')\"";
    'es-index-create-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => [ Exec[ 'es-config-command' ], Service[ $::zammad::service_elasticsearch ] ],
      refreshonly => true,
      command     => $::zammad::es_index_create_command;
    'rmv-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package['curl'],
      refreshonly => true,
      command     => $::zammad::rvm_install_command;
  }

  if $::zammad::package_manage_database == true {
    package { $::zammad::package_database:
      ensure  => 'installed';
    }
  }

  if $::zammad::package_manage_elasticsearch == true {
    package { $::zammad::package_elasticsearch:
      ensure  => 'installed',
      require => Exec[ 'es-repo-key-install' ];
    }
  }

  if $::zammad::package_manage_webserver == true {
    package { $::zammad::package_webs::paramserver:
      ensure  => 'installed';
    }
  }

}
