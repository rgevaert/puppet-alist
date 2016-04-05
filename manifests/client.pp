# Class: alist::client
# ===========================
#
# Sets up alist client
#
class alist::client ( $alist_server = $::alist::params::alist_server)
  inherits ::alist::params {

  package {
    'alist-client':
      ensure => present;
  }

  file {
    '/etc/alist/client.cf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['alist-client'],
      content => template('alist/client.cf.erb');
  }

  file{
    '/etc/default/alist-client':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['alist-client'],
      content => template('alist/alist-client.erb');
  }

}
