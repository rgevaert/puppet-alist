# == Class alist::params
#
# This class is meant to be called from alist.
# It sets variables according to platform.
#
class alist::params {

  $alist_server  = "alist.${::domain}"
  $deny_clients  = ''
  $allow_clients = [ $::network_eth0 ]
  $start_server  = 'true'

  case $::osfamily {
    'Debian', 'Redhat': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
