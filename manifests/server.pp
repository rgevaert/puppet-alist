# Class: alist::server
# ===========================
#
# Sets up alist server
#
class alist::server ( $start_server  = $::alist::params::start_server,
                      $deny_clients  = $::alist::params::deny_clients,
                      $allow_clients = $::alist::params::allow_clients
) inherits ::alist::params {

  include ::apache

  package { 'alist-server':
    ensure => present;
  }

  package { 'alist-web':
    ensure  => present,
    require => [ Package['alist-server'], Class['apache']];
  }

  file{ '/etc/default/alist-server':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['alist-server'],
    content => template('alist/alist-server.erb');
  }

  file { '/etc/alist/server.cf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['alist-server'],
    content => template('alist/server.cf.erb');
  }

  file { '/etc/apache2/conf.d/alist.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['alist-web'],
    source  => 'puppet:///modules/alist/apache.conf',
  }

  $service_ensure = $start_server ? {
    'true'  => 'running',
    default => 'stopped',
  }

  service { 'alist-server':
    ensure     => $service_ensure,
    hasrestart => true,
    hasstatus  => false,
    status     => '/usr/bin/pgrep alistd',
    require    => [ File['/etc/default/alist-server'], File['/etc/alist/server.cf']],
  }
}
