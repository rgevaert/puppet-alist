# == Class alist::service
#
# This class is meant to be called from alist.
# It ensure the service is running.
#
class alist::service {

  service { $::alist::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
