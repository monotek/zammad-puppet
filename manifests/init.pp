# Class: zammad
class zammad (
  $zammad_domain             = $::zammad::params::zammad_domain,
  $zammad_branch             = $::zammad::params::zammad_branch,
  $package_ensure            = $::zammad::params::package_ensure,
  $service_ensure            = $::zammad::params::service_ensure,
  $repo_key_command          = $::zammad::params::repo_key_command,
  $repo_file                 = $::zammad::params::repo_file,
  $repo_template             = $::zammad::params::repo_template,
  $package_database          = $::zammad::params::package_database,
  $package_webserver         = $::zammad::params::package_webserver,
  $package_elasticsearch     = $::zammad::params::service_elasticsearch,
  $service_database          = $::zammad::params::service_database,
  $service_webserver         = $::zammad::params::service_webserver,
  $service_zammad            = $::zammad::params::service_zammad,
  $webserver_template        = $::zammad::params::webserver_template,
  $es_url                    = $::zammad::params::es_url,
  $es_plugin_install_command = $::zammad::params::es_plugin_install_command,
  $es_config_command         = $::zammad::params::es_config_command,
  $es_index_create_command   = $::zammad::params::es_index_create_command,
) inherits zammad::params {

  include zammad::install

}
