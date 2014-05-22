
class nginx-site-example {

# Create nginx user
user { 'www-nginx':
   ensure => present,
}

# Set the corresponding update repo command and ensure supported
# operating systems
case $operatingsystem {
      centos, fedora: { $repo_update_cmd = "/usr/bin/yum makecache"}
      ubuntu, debian: { $repo_update_cmd = "/usr/bin/apt-get update"}
      default: { fail("Operating system not supported") }
}

# Epel must be installed in centos to make nginx available from a yum repository
if $operatingsystem == "centos" {

    file { 'epel-key-6':
     path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
     ensure => file,
     source => 'puppet:///modules/nginx/RPM-GPG-KEY-EPEL-6',
    }

    exec { 'import-epel-key':
      command => "/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6",
      unless => "/bin/rpm -qi gpg-pubkey-0608b895-4bd22942",
      require => File['epel-key-6'],
    }

    package { 'epel-release-6-8.noarch':
       ensure => present,
       source => "http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm",
       provider => rpm,
       require => Exec['import-epel-key'],
       before => Exec['update repo'],
    }
}

# In the case of fedora we have to disable the firewall
if $operatingsystem == "fedora" {
  service { 'firewall-down':
    name => "firewalld",
    ensure => stopped,
    before => Service['nginx'],
  }
}

# Update packages information.
# This command is only necessary if nginx is not installed to update the repo
exec { 'update repo':
   command => $repo_update_cmd,
   unless => "/bin/ls /etc/nginx/nginx.conf",
}

# Install nginx package
package { 'nginx':
   ensure => present,
   require => Exec['update repo'],
}



# Ensure nginx is running
service { 'nginx':
   ensure => running,
   require => [
      Package['nginx'],
   ],
}

# Copy nginx configuration file
file { 'nginx-conf':
   path => '/etc/nginx/nginx.conf',
   ensure => file,
   replace => true,
   owner => 'root',
   group => 'root',
   mode => '644',
   require => [
      Package['nginx'],
      User['www-nginx'],
   ],
   source => 'puppet:///modules/nginx/nginx.conf',
   notify => Service['nginx'],
}


# Ensure sites directories
file { 'nginx-sites-available-dir':
   path => '/etc/nginx/sites-available',
   ensure => directory,
   replace => true,
   owner => 'root',
   group => 'root',
   mode => '755',
   require => Package['nginx'],
}

file { 'nginx-sites-enabled-dir':
   path => '/etc/nginx/sites-enabled',
   ensure => directory,
   replace => true,
   owner => 'root',
   group => 'root',
   mode => '755',
   require => Package['nginx'],
}


# Copy site configuration file
file { 'nginx-site-example-conf':
   path => '/etc/nginx/sites-available/site-example',
   ensure => file,
   replace => true,
   owner => 'root',
   group => 'root',
   mode => '644',
   require => [
      Package['nginx'],
      File['nginx-sites-available-dir'],
   ],
   source => 'puppet:///modules/nginx/site-example',
   notify => Service['nginx'],
}

# Some nginx distribution comes with a default site, let's disable it
file { 'default-nginx-disable':
   path => '/etc/nginx/sites-enabled/default',
   ensure => absent,
   require => [
       Package['nginx'],
       File['nginx-sites-enabled-dir'],
   ],
   notify => Service['nginx'],
}

# Enable site creating the symbolink link
file { 'site-example-nginx-enable':
   path => '/etc/nginx/sites-enabled/site-example',
   target => '/etc/nginx/sites-available/site-example',
   ensure => link,
   notify => Service['nginx'],
   require => [
      File['nginx-site-example-conf'],
      File['nginx-sites-enabled-dir'],
      File['default-nginx-disable'],
   ],
}

}

include nginx-site-example
