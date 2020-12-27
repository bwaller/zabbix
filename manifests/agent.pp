$hostmetadata = "$kernel $hostname $kernelrelease $environment $domain"

class { 'zabbix::agent':
  server       => '192.168.10.10',
  serveractive => '192.168.10.10',
}

->

file { '/etc/zabbix/zabbix_agentd.d/hostmetadata.conf':
  ensure  => file,
  content => template('mytemplates/hostmetadata.erb'),
}
