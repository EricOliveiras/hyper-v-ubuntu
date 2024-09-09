Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"

  config.vm.provider "hyperv" do |h|
    h.memory = 2048  
    h.cpus = 2      
  end

  config.vm.network "public_network", type: "dhcp"

  config.vm.network "forwarded_port", guest: 22, host: 2222
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision "shell", path: "script.sh"
end
