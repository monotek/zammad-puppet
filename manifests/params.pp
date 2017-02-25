# Class: zammad::params
class zammad::params {
  $zammad_domain             = 'localhost'
  $zammad_branch             = 'stable'
  $package_ensure            = 'installed'
  $service_ensure            = 'running'
  $service_zammad            = 'zammad'
  $es_url                    = 'http://127.0.0.1:9200'
  $es_plugin_install_command = '/usr/share/elasticsearch/bin/elasticsearch-plugin install mapper-attachments'
  $es_config_command         = "zammad run rails r \"Setting.set('es_url', ${es_url})\""
  $es_index_create_command   = 'zammad run rake searchindex:rebuild'
  $repo_template             = 'repo.erb'
  case $::operatingsystem {
    /^(CentOS|RedHat)$/: {
      $repo_key_command      = 'rpm --import https://rpm.packager.io/key'
      $repo_file             = '/etc/yum.repos.d/zammad.repo'
      $package_database      = 'postgresql-server'
      $package_webserver     = 'nginx'
      $package_elasticsearch = 'elasticsearch'
      $service_database      = 'postgresql-server'
      $service_webserver     = 'nginx'
      $service_elasticsearch = 'elasticsearch'
      if $package_webserver == 'nginx' {
        $webserver_config   = '/etc/nginx/conf.d/zammad.conf'
        $webserver_template = 'nginx.conf.erb'
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config   = '/etc/httpd/conf.d/zammad.conf'
        $webserver_template = 'apache2.conf.erb'
      }
    }
    /^(Debian|Ubuntu)$/: {
      $repo_key_command      = 'wget -qO - https://deb.packager.io/key | apt-key add -;apt update'
      $repo_file             = '/etc/apt/sources.list.d/zammad.list'
      $package_database      = 'postgresql'
      $package_webserver     = 'nginx'
      $package_elasticsearch = 'elasticsearch'
      $service_database      = 'postgresql'
      $service_webserver     = 'nginx'
      $service_elasticsearch = 'elasticsearch'
      if $package_webserver == 'nginx' {
        $webserver_config   = '/etc/nginx/sites-enabled/zammad.conf'
        $webserver_template = 'nginx.conf.erb'
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config   = '/etc/apache2/sites-enabled/zammad.conf'
        $webserver_template = 'apache2.conf.erb'
      }
    }
    /^(SLES|SUSE)$/: {
      $repo_key_command      = 'rpm --import https://rpm.packager.io/key'
      $repo_file             = '/etc/zypp/repos.d/zammad'
      $package_database      = 'postgresql-server'
      $package_webserver     = 'nginx'
      $package_elasticsearch = 'elasticsearch'
      $service_database      = 'postgresql-server'
      $service_webserver     = 'nginx'
      $service_elasticsearch = 'elasticsearch'
      if $package_webserver == 'nginx' {
        $webserver_config   = '/etc/nginx/vhosts.d/zammad.conf'
        $webserver_template = 'nginx.conf.erb'
      }
      elsif $package_webserver == 'apache2' {
        $webserver_config   = '/etc/apache2/vhosts.d/zammad.conf'
        $webserver_template = 'apache2.conf.erb'
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
