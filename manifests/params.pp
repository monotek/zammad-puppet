# Class: zammad::params
class zammad::params (
  $branch                    = 'stable',
  $package_ensure            = 'installed',
  $service_ensure            = 'running',
  $service_zammad            = 'zammad',
  $zammad_domain             = 'localhost',
  $es_plugin_install_command = '',
  case $::operatingsystem {
    /^(CentOS|RedHat)$/: {
      $repo_key_command      = 'rpm --import https://rpm.packager.io/key'
      $repo_file             = '/etc/yum.repos.d/zammad.repo'
      $package_database      = 'postgresql-server',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql-server',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch',
      if $package_webserver == 'nginx' {
        $webserver_config      = '/etc/nginx/sites-enables/zammad.conf';
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config      = '/etc/apache2/sites-enables/zammad.conf';
      }
    }
    /^(Debian|Ubuntu)$/: {
      $repo_key_command      = 'wget -qO - https://deb.packager.io/key | apt-key add -'
      $repo_file             = '/etc/apt/sources.list.d/zammad.list'
      $package_database      = 'postgresql',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch';
      if $package_webserver == 'nginx' {
        $webserver_config      = '/etc/nginx/sites-enables/zammad.conf';
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config      = '/etc/apache2/sites-enables/zammad.conf';
      }
    }
    /^(SLES|SUSE)$/: {
      $repo_key_command      = 'rpm --import https://rpm.packager.io/key'
      $repo_file             = '/etc/zypp/repos.d/zammad'
      $package_database      = 'postgresql-server',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql-server',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch';
      if $package_webserver == 'nginx' {
        $webserver_config      = '/etc/nginx/sites-enables/zammad.conf';
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config      = '/etc/apache2/sites-enables/zammad.conf';
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
