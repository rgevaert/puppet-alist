# == Class alist::install
#
# This class is called from alist for install.
#
class alist::install {

  package { $::alist::package_name:
    ensure => present,
  }
}
