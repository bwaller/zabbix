include '::mysql::server'

package { ['zabbix-server-mysql',
           'zabbix-frontend-php']:
  ensure => installed,
}

->

mysql::db { 'zabbix':
  user     => 'zabbix',
  password => 'changeme',
  host     => 'localhost',
  grant    => ['ALL'],
}

~>

exec { 'Create zabbix database schema':
  command     => '/bin/zcat /usr/share/zabbix-server-mysql/schema.sql.gz | /usr/bin/mysql -u zabbix -pchangeme zabbix',
  refreshonly => true,
}

->

file_line { 'zabbix dbpassword':
      path => '/etc/zabbix/zabbix_server.conf',
      line => 'DBPassword=changeme',
}

->

file_line { 'zabbix dbhost':
      path => '/etc/zabbix/zabbix_server.conf',
      line => 'DBHost=localhost',
}

service { 'apache2':
  ensure => running,
  enable => true,
}

service { 'zabbix-server':
  ensure => running,
  enable => true,
}

Package['zabbix-frontend-php']
->
File_line['zabbix dbpassword','zabbix dbhost'] 
~> Service['apache2','zabbix-server']

