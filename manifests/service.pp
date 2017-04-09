# class zammad::service
class zammad::service {
  service {
    $::zammad::service_database:
      ensure  => running;
    $::zammad::service_elasticsearch:
      ensure  => running,
      require => Exec[ 'es-plugin-install' ];
    $::zammad::service_webserver:
      ensure  => running;
    $::zammad::service_zammad:
      ensure  => running;
  }
}
