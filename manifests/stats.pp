# == Class: webserver::stats
#
# Full description of class webserver::stats here
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
#  class { 'webserver::stats':
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
class webserver::stats (
  $db_user     = 'admin',
  $db_password = 'admin',
  $hostname    = 'stats.yakshed.dev'
){

  package { ['php5-geoip', 'php5-cli']:
    ensure => present
  }

  nginx::resource::vhost { $hostname:
    ensure   => present,
    www_root => "/var/www/piwik",
    index_files => ['index.php'],
    try_files => ['$uri','$uri/','/index.php$is_args$args'],
    ssl      => true,
    ssl_cert => "/etc/ssl/certs/${hostname}.crt",
    ssl_key  => "/etc/ssl/private/${hostname}.key"
  }

  nginx::resource::location {"stats-upstream":
    ensure   => present,
    ssl      => true,
    vhost    => $hostname,
    www_root => "/var/www/piwik",
    location => '~ \.php$',
    fastcgi  => 'php-fpm'
  }

  class { 'piwik':
    path         => "/var/www/piwik",
    user         => "www-data",
    db_name      => 'piwik',
    db_user      => $db_user,
    db_password  => $db_password,
    db_host      => 'localhost',
    require      => Package['unzip']
  }

  file { '/var/log/piwik':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data'
  }

  cron { 'piwik-archive':
    ensure => present,
    command => "/usr/bin/php /var/www/piwik/console core:archive --url=http://${hostname}/ > /var/log/piwik/archive.log",
    minute  => '5',
    hour    => '*',
    user    => 'www-data'
  }
}
