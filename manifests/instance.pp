# zammad::instance
define zammad::instance (
  String $zammad_instance_name                = $title,
  Integer $zammad_instance_id                 = fqdn_rand($::zammad::params::zammad_max_instances, $zammad_instance_name),
  String $zammad_domain                       = undef,
  String $zammad_user                         = "${::zammad::params::zammad_default_user}_${zammad_instance_name}",
  Stdlib::Absoultepath $zammad_home_directory = "${::zammad::params::zammad_default_home_directory}_${zammad_instance_name}",
  Stdlib::Absoultepath $zammad_base_directory = dirname($zammad_home_directory),
  Integer $zammad_rails_port                  = $::zammad::params::zammad_default_rails_port + $zammad_instance_id,
  Integer $zammad_websocker_port              = $::zammad::params::zammad_default_websocket_port + $zammad_instance_id,
  Stdlib::Httpsurl $zammad_git_repo           = $::zammad::params::zammad_git_repo,
  Optional[String] $zammad_branch             = $::zammad::params::zammad_branch,
  String $database                            = $::zammad::params::database,
  String $webserver                           = $::zammad::params::webserver,
) {

  group { '$zammad_user':
    ensure  => present;
  }

  user { $zammad_user:
    ensure  => present,
    home    => $zammad_home_directory,
    group   => $zammad_user,
    require => User[$zammad_user],
    shell   => '/bin/bash';
  }

  if $database == 'postgresql' {
    create_db_command = ''
  }
  elsif  $databse == 'mysql' {
    create_db_command = ''
  }

  exec {
    'git clone':
      command => "cd ${zammad_base_directory};git clone ${zammad_git_repo} --branch ${zammad_branch}",
      creates => $zammad_home_directory,
      require => File[$zammad_base_directory];
    'fetch locales':
      command => "cd ${zammad_home_directory};contrib/packager.io/fetch_locales.rb",
      require => File[$zammad_home_directory];
    'create db'
      command => '',
      require => Package[$database];
    'bundle tasks':
      command => "cd ${zammad_base_directory};bundle exec rake db:migrate;bundle exec rake db:seed;bundle exec rake assets:precompile";
    'es index':
      command => '';
  }


  file {
    $zammad_base_directory:
      ensure => directory,
      path   => $zammad_base_directory;
    $zammad_home_directory:
      ensure => directory,
      owner  => $zammad_user,
      group  => $zammad_user,
      mode   => '0750'
      path   => $zammad_home_directory;

  }




}
