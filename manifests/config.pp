# == Class: webserver::config
#
# Full description of class webserver::config here
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
#  class { 'webserver::config':
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
class webserver::config {

  include 'php'
  class { 'php::extension::apc': }
  class { 'php::extension::mysql': }
  class { 'php::extension::mcrypt': }
  class { 'php::extension::gd': }

  class { 'php::fpm::daemon':
    ensure => running
  }

  class { 'nginx':
    worker_processes   => 10,
    worker_connections => 2048,
    confd_purge        => true,
    server_tokens      => off,
  }

  nginx::resource::upstream { 'php-fpm':
    ensure  => present,
    members => [ 'unix:/var/run/php5-fpm.sock' ],
  }

  nginx::resource::vhost { $::fqdn:
    ensure   => present,
    listen_options => 'default',
    www_root       => '/dev/null'
  }

  file { '/var/www':
    ensure => directory
  }
}
