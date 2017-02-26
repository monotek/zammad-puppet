# Class: zammad::params
class zammad::params {
  $zammad_domain                = 'localhost'
  $zammad_branch                = 'stable'
  $zammad_repo_template         = 'zammad_repo.erb'
  $package_manage_database      = true
  $package_manage_elasticsearch = true
  $package_manage_webserver     = true
  $package_manage_zammad        = true
  $package_zammad               = 'zammad'
  $es_url                       = 'http://127.0.0.1:9200'
  $es_plugin_install_command    = '/usr/share/elasticsearch/bin/elasticsearch-plugin install mapper-attachments'
  $es_config_command            = "zammad run rails r \"Setting.set('es_url', ${es_url})\""
  $es_index_create_command      = 'zammad run rake searchindex:rebuild'
  $es_version                   = '5.x'
  case $::operatingsystem {
    /^(CentOS|RedHat)$/: {
      $es_repo_key_command     = 'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch'
      $es_repo_file            = '/etc/yum.repos.d/elasticsearch.repo'
      $zammad_repo_key_command = 'rpm --import https://rpm.packager.io/key'
      $zammad_repo_file        = '/etc/yum.repos.d/zammad.repo'
      $package_database        = 'postgresql-server'
      $package_elasticsearch   = 'elasticsearch'
      $package_webserver       = 'nginx'
      $service_database        = 'postgresql'
      $service_elasticsearch   = 'elasticsearch'
      $service_webserver       = 'nginx'
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
      $es_repo_key_command     = 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -;apt update'
      $es_repo_file            = '/etc/apt/sources.list.d/elasticsearch.list'
      $zammad_repo_key_command = 'wget -qO - https://deb.packager.io/key | apt-key add -;apt update'
      $zammad_repo_file        = '/etc/apt/sources.list.d/zammad.list'
      $package_database        = 'postgresql'
      $package_elasticsearch   = 'elasticsearch'
      $package_webserver       = 'nginx'
      $service_database        = 'postgresql'
      $service_elasticsearch   = 'elasticsearch'
      $service_webserver       = 'nginx'
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
      $es_repo_key_command     = 'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch'
      $es_repo_file            = '/etc/zypp/repos.d/elasticsearch'
      $zammad_repo_key_command = 'rpm --import https://rpm.packager.io/key'
      $zammad_repo_file        = '/etc/zypp/repos.d/zammad'
      $package_database        = 'postgresql-server'
      $package_elasticsearch   = 'elasticsearch'
      $package_webserver       = 'nginx'
      $service_database        = 'postgresql-server'
      $service_elasticsearch   = 'elasticsearch'
      $service_webserver       = 'nginx'
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
