# class zammad::install
class zammad::install {

  file {
    $::zammad::params::es_repo_file:
      ensure  => file,
      path    => $::zammad::params::es_repo_file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Exec['es-repo-key-install'],
      content => template("zammad/${::zammad::params::es_repo_template}");
    $::zammad::params::zammad_repo_file:
      ensure  => file,
      path    => $::zammad::params::zammad_repo_file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Exec['zammad-repo-key-install'],
      content => template("zammad/${::zammad::params::zammad_repo_template}");
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
    'es-repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $::zammad::params::es_repo_file ],
      refreshonly => true,
      command     => $::zammad::params::es_repo_key_command;
    'es-plugin-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package[ $::zammad::params::package_elasticsearch ],
      creates     => '/usr/share/elasticsearch/plugins/mapper-attachments',
      notify      => Service[ $::zammad::params::service_elasticsearch ],
      refreshonly => true,
      command     => $::zammad::params::es_plugin_install_command;
    'es-config-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => Package[ $::zammad::params::package_zammad ],
      notify      => Exec[ 'es-index-create-command' ],
      refreshonly => true,
      command     => $::zammad::params::es_config_command;
    'es-index-create-command':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => [ Exec[ 'es-config-command' ], Service[ $::zammad::params::service_elasticsearch ] ],
      refreshonly => true,
      command     => $::zammad::params::es_index_create_command;
    'zammad-repo-key-install':
      path        => '/usr/bin/:/bin/:sbin/',
      require     => File[ $::zammad::params::zammad_repo_file ],
      refreshonly => true,
      command     => $::zammad::params::zammad_repo_key_command;
  }

  if $::zammad::params::package_manage_database == true {
    package { $::zammad::params::package_database:
      ensure  => 'installed';
    }
  }

  if $::zammad::params::package_manage_elasticsearch == true {
    package { $::zammad::params::package_elasticsearch:
      ensure  => 'installed',
      require => Exec[ 'es-repo-key-install' ];
    }
  }

  if $::zammad::params::package_manage_webserver == true {
    package { $::zammad::params::package_webserver:
      ensure  => 'installed';
    }
  }

  if $::zammad::params::package_manage_zammad == true {
    package { $::zammad::params::package_zammad:
      ensure  => 'installed',
      notify  => Exec[ 'es-config-command' ],
      require => [ Exec[ 'zammad-repo-key-install' ], Package[ $::zammad::params::package_database, $::zammad::params::package_elasticsearch, $::zammad::params::package_webserver ] ];
    }
    service {
      $::zammad::params::service_elasticsearch:
        ensure  => running,
        require => Exec[ 'es-plugin-install' ];
      $::zammad::params::service_webserver:
        ensure  => running,
        require => File[ $::zammad::params::webserver_config ];
    }
  }
  else {
    package { $::zammad::params::package_zammad:
      ensure  => 'absent';
    }
    service { $::zammad::params::service_zammad:
      ensure  => stopped;
    }
  }

}
