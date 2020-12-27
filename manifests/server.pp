class { 'apache':
  mpm_module => 'prefork',
}
include apache::mod::php

class { 'mysql::server': }

mysql::db { 'zabbix_server':
  user     => 'zabbix_server',
  password => 'zabbix_server',
  host     => 'localhost',
  grant    => ['ALL'],
}

class { 'zabbix':
  zabbix_url      => 'zabbix.example.com',
  database_type   => 'mysql',
  zabbix_version  => '5.2',
  manage_database => false,
}

->

class { 'zabbix::agent':
  server => '127.0.0.1',
}

exec { 'Create zabbix database schema':
  command     => '/bin/zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | /usr/bin/mysql -u zabbix_server -pzabbix_server zabbix_server',
  refreshonly => true,
}

Package[zabbix-server-mysql] ~> Exec['Create zabbix database schema']
Mysql_database[zabbix_server] ~> Exec['Create zabbix database schema']
