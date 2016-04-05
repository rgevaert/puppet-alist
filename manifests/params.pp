# == Class alist::params
#
# This class is meant to be called from alist.
# It sets variables according to platform.
#
class alist::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'alist'
      $service_name = 'alist'
    }
    'RedHat', 'Amazon': {
      $package_name = 'alist'
      $service_name = 'alist'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
