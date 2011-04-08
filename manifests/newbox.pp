class repo {
  package { "rpmforge-release":
      ensure => latest,
      require => Exec["rpmforge-bootstrap"],
  }

  exec { "rpmforge-bootstrap":
      command   => "/bin/bash -l -c \'rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.$dist.rf.$arch.rpm\'",
      unless    => "/bin/bash -l -c \'rpm -qa | grep rpmforge-release\'",
  }
}

class packages {
  require repo
  package { "git":
    ensure => latest,
  }
  package { "telnet":
    ensure => latest,
  }
}

class ree-packages {
  require repo
  package { "gcc-c++":
    ensure => latest,
  }

  package { "patch":
    ensure => latest,
  }

  package { "readline":
    ensure => latest,
  }

  package { "readline-devel":
    ensure => latest,
  }

  package { "zlib":
    ensure => latest,
  }

  package { "zlib-devel":
    ensure => latest,
  }

  package { "libyaml-devel":
    ensure => latest,
  }

  package { "libffi-devel":
    ensure => latest,
  }

  package { "openssl-devel":
    ensure => latest,
  }

}

class passenger-packages {
  require repo
  package { "curl-devel":
    ensure => latest,
  }
}

class mysql {
  require repo
  package { "mysql":
    ensure => latest,
  }
  package { "mysql-server":
    ensure => latest,
  }
  package { "mysql-devel":
    ensure => latest,
  }
  file { "/etc/init.d/mysqld":
    notify => Service['mysqld'],
    require => Package['mysql-server'],
  }
  service { "mysqld":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}

class users {
  user { "smcleod":
    ensure   => present,
    password => '$1$oyQG68gO$wFPimaAPy6HHKUO5T6fes/',
    shell => "/bin/bash",
    managehome => true,
  }
  user { "root":
    ensure => present,
    password => '$1$AngEdXN6$50WWV.gV.m7hkogEwQi6W.',
    shell => "/bin/bash",
  }
}

class sqlite {
  exec { "download-sqlite":
    command   => "/bin/bash -l -c \'wget http://www.sqlite.org/sqlite-autoconf-3070500.tar.gz -O /root/sqlite.tar.gz\'",
    user      => "root",
    unless    => "/usr/bin/test -f /usr/local/lib/libsqlite3.so",
  }

  exec { "unpack-sqlite":
    command   => "/bin/bash -l -c \'tar zxvf sqlite.tar.gz\'",
    user      => "root",
    cwd       => "/root",
    unless    => "/usr/bin/test -f /usr/local/lib/libsqlite3.so",
    require   => Exec["download-sqlite"],
  }

  exec { "compile-sqlite":
    command   => "/bin/bash -l -c \'./configure; make ; make install\'",
    cwd       => "/root/sqlite-autoconf-3070500",
    unless    => "/usr/bin/test -f /usr/local/lib/libsqlite3.so",
    require   => Exec["unpack-sqlite"],
  }

  exec { "remove-src":
    command => "/bin/bash -l -c \'rm -rf /root/sqlite-autoconf-3070500\'",
    onlyif  => "/usr/bin/test -d /root/sqlite-autoconf-3070500",
    require => Exec["compile-sqlite"],
  }

  exec { "remove-tarball":
    command => "/bin/bash -l -c \'rm -rf /root/sqlite.tar.gz\'",
    onlyif  => "/usr/bin/test -f /root/sqlite.tar.gz",
    require => Exec["remove-src"],
  }

}

class rvm {
  require packages, ree-packages, passenger-packages, mysql, sqlite
  exec { "install-rvm":
    command => "/bin/bash -l -c \'bash < <(curl -B https://rvm.beginrescueend.com/install/rvm)\'",
    user    => "root",
    unless  => "/usr/bin/test -d /usr/local/rvm",
  }
  exec { "install-ree":
    command => "/bin/bash -l -c \'rvm install ree\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'rvm list | grep ree\'",
    require => Exec["install-rvm"],
  }
  exec { "passenger-gem":
    command => "/bin/bash -l -c \'rvm use ree; gem install passenger\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'rvm use ree; gem list | grep passenger\'",
    require => Exec["install-ree"],
  }
  exec { "passenger-nginx":
    command => "/bin/bash -l -c \'rvm use ree; passenger-install-nginx-module --prefix=/opt/nginx --auto --auto-download\'",
    user    => "root",
    unless  => "/usr/bin/test -f /opt/nginx/sbin/nginx",
    require => Exec["passenger-gem"],
  }
  file { "nginx.conf":
    path => "/opt/nginx/conf/nginx.conf",
    source => "puppet:///modules/nginx/nginx.conf",
    owner  => "root",
    group  => "root",
    require => Exec["passenger-nginx"],
  }
  exec { "nginx-start":
    command => "/bin/bash -l -c \'/opt/nginx/sbin/nginx\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'ps -eaf | grep `cat /opt/nginx/logs/nginx.pid 2>/dev/null` > /dev/null 2>&1\'",
    require => File["nginx.conf"],
  }
  exec { "allow-http":
    command => "/bin/bash -l -c \'iptables -I RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT\'",
    user => "root",
    unless => "/bin/bash -l -c \'iptables -L RH-Firewall-1-INPUT | grep dpt:http\'",
    require => Exec["nginx-start"],
  }
  file{ "/websites":
    ensure => directory,
  }
  file{ "/websites/phusion":
    ensure => directory,
  }
  file { "/websites/phusion/rails":
    ensure => link,
    target => "/vagrant_data/railsapp/public",
  }
}

class gems {
  require rvm, sqlite, mysql
  exec { "sqlite-gem":
    command => "/bin/bash -l -c \'rvm use ree; gem install sqlite3\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'rvm use ree; gem list | grep sqlite3\'",
  }
  exec { "rails-gems":
    command => "/bin/bash -l -c \'rvm use ree; gem install rails\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'rvm use ree; gem list | grep rails\'",
  }
  exec { "mysql2-gem":
    command => "/bin/bash -l -c \'rvm use ree; gem install mysql2\'",
    user    => "root",
    unless  => "/bin/bash -l -c \'rvm use ree; gem list | grep mysql2\'",
    require => Package["mysql-devel"],
  }
}


include users
include rvm
include gems
