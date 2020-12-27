Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vagrant.plugins = ["vagrant-puppet-install", 
                            "vagrant-vbguest",
                            "vagrant-pristine"]

  config.puppet_install.puppet_version = '5.5.22'

  config.librarian_puppet.puppetfile_dir = "."

  config.vm.define "server" do |server|
    server.vm.hostname = "server"
    server.vm.network "forwarded_port", guest: 80, host: 8080
    server.vm.network "private_network", ip: "192.168.10.10"
    server.vm.provision "puppet" do |p|
      p.manifest_file = "server.pp"
      p.module_path = "modules"
    end
  end

  config.vm.define "agent1" do |agent|
    agent.vm.hostname = "agent1"
    agent.vm.network "private_network", ip: "192.168.10.20"
    agent.vm.provision "puppet" do |p|
      p.manifest_file = "agent.pp"
      p.module_path = ["modules", "mymodules"]
    end
  end

end
