# == Class: webserver::baschtdotcom
#
# Full description of class webserver::baschtdotcom here
#
# === Parameters
#
# Document parameters here.
#
# [*parameter1*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*variable1*]
#   Explanation of how this variable affects the funtion of this class and
#   if it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames."
#
# === Examples
#
#  class { 'webserver::baschtdotcom':
#    parameter1 => [ 'just', 'an', 'example', ]
#  }
#
# === Authors
#
# Sebastian Schulze <github.com@bascht.com> <github.com@bascht.com>
#
# === Copyright
#
# Copyright 2014 Sebastian Schulze <github.com@bascht.com>
#
class webserver::isiclouddowndotcom (
  $hostname = 'www.isiclouddown.com',
  $file_owner,
){
  file { '/var/www/isiclouddown.com':
    ensure => directory,
    owner  => $file_owner,
  }

  nginx::resource::vhost { $hostname:
    ensure   => present,
    www_root => '/var/www/isiclouddown.com',
    ssl      => false,
    rewrite_www_to_non_www => false
  }

  require webserver::config
}
