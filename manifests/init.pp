# Class: zammad
class zammad (
  $zammad_branch             = $::zammad::params::zammad_branch,
  $zammad_domain             = $::zammad::params::zammad_domain,
  $zammad_repo_file          = $::zammad::params::repo_file,
  $zammad_repo_key_command   = $::zammad::params::repo_key_command,
  $zammad_repo_template      = $::zammad::params::repo_template,
  $package_database          = $::zammad::params::package_database,
  $package_elasticsearch     = $::zammad::params::package_elasticsearch,
  $package_webserver         = $::zammad::params::package_webserver,
  $package_zammad            = $::zammad::params::package_zammad,
  $service_ensure            = $::zammad::params::service_ensure,
  $service_database          = $::zammad::params::service_database,
  $service_elasticsearch     = $::zammad::params::service_elasticsearch,
  $service_webserver         = $::zammad::params::service_webserver,
  $service_zammad            = $::zammad::params::service_zammad,
  $webserver_template        = $::zammad::params::webserver_template,
  $es_url                    = $::zammad::params::es_url,
  $es_plugin_install_command = $::zammad::params::es_plugin_install_command,
  $es_config_command         = $::zammad::params::es_config_command,
  $es_index_create_command   = $::zammad::params::es_index_create_command,
  $es_version                = $::zammad::params::es_version,
  $es_repo_key_command       = $::zammad::params::es_repo_key_command,
  $es_repo_file              = $::zammad::params::es_repo_file,
) inherits zammad::params {

  include zammad::install

}
