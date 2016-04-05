# Class: alist
# ===========================
#
# Full description of class alist here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class alist (
  $package_name = $::alist::params::package_name,
  $service_name = $::alist::params::service_name,
) inherits ::alist::params {

  # validate parameters here

  class { '::alist::install': } ->
  class { '::alist::config': } ~>
  class { '::alist::service': } ->
  Class['::alist']
}
