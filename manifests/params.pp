# Class: zammad::params
class zammad::params (
  $branch         = 'stable',
  $package_ensure = 'installed',
  $service_ensure = 'running',
  $service_zammad = 'zammad',
  case $::operatingsystem {
    /^Debian$/: {
      $repo_key_command      = 'wget -qO - https://deb.packager.io/key | apt-key add -'
      $repo_file             = '/etc/apt/sources.list.d/zammad.list'
      $package_database      = 'postgresql',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch';
    }
    /^(CentOS|RedHat)$/: {
      $repo_key_command      = 'rpm --import https://rpm.packager.io/key'
      $repo_file             = '/etc/yum.repos.d/zammad.repo'
      $package_database      = 'postgresql-server',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql-server',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch';
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
    }
    /^Ubuntu$/: {
      $repo_key_command      = 'wget -qO - https://deb.packager.io/key | apt-key add -'
      $repo_file             = '/etc/apt/sources.list.d/zammad.list'
      $package_database      = 'postgresql',
      $package_webserver     = 'nginx',
      $package_elasticsearch = 'elasticsearch';
      $service_database      = 'postgresql',
      $service_webserver     = 'nginx',
      $service_elasticsearch = 'elasticsearch';
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
