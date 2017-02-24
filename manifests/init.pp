# Class: zammad
class zammad (
  $branch                 = $::zammad::params::branch,
  $package_ensure         = $::zammad::params::package_ensure,
  $service_ensure         = $::zammad::params::service_ensure,
  $repo_key_command       = $::zammad::params::repo_key_command,
  $repo_file              = $::zammad::params::repo_file,
  $zammad_domain          = $::zammad::params::zammad_domain,
  $package_database       = $::zammad::params::package_database,
  $package_webserver      = $::zammad::params::package_webserver,
  $package_elasticsearch  = $::zammad::params::service_elasticsearch,
  $service_database       = $::zammad::params::service_database,
  $service_webserver      = $::zammad::params::service_webserver,
  $service_zammad         = $::zammad::params::service_zammad,
) inhertis zammad::params {

  include zammad::install

}
