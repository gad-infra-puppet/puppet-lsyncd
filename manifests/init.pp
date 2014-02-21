# Class: lsyncd
#
# lsyncd.
#
# Sample Usage :
#  class { 'lsyncd': config_source => 'puppet:///modules/example/lsyncd.conf' }
#
class lsyncd (
  $ensure         = present,
  $logdir_owner   = 'root',
  $logdir_group   = 'root',
  $logdir_mode    = '0755',
  $conf_file      = '/etc/lsyncd.conf',
) {

  package { 'lsyncd': ensure => installed }

  if ($ensure == 'present') {
    $run_service = true
    $service_state = 'running'
  } else {
    $run_service = false
    $service_state = 'stopped'
  }

  service { 'lsyncd':
    enable    => $run_service,
    ensure    => $service_state,
    hasstatus => true,
    require   => Package['lsyncd'],
  }

  concat { $conf_file :
    owner => root,
    group => root,
    mode  => '0644',
    notify  => Service['lsyncd'],
    require => Package['lsyncd'],
  }

  if defined(Class['csync2']) {
    if $csync2::csync2_confdir {
      $csync2_confdir = $csync2::csync2_confdir      
    }
  } else {
    $csync2_confdir = '/etc/csync2'
  }

  concat::fragment{ "lsyncd_header":
    target  => $conf_file,
    content => template('lsyncd/lsyncd_csync2_header.erb'),
    order   => 01,
  }

  concat::fragment{ "lsyncd_footer":
    target => $conf_file,
    content => template('lsyncd/lsyncd_csync2_footer.erb'),
    order   => 15,
  }

  # As of 2.1.4-3.el6 the rpm package doesn't include this directory
  file { '/var/log/lsyncd':
    owner  => $logdir_owner,
    group  => $logdir_group,
    mode   => $logdir_mode,
    ensure => directory,
  }

}

