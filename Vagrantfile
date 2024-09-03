Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"

  config.vm.provider "hyperv" do |h|
    h.memory = 2048  
    h.cpus = 2      
  end

  config.vm.network "public_network"

  config.vm.network "forwarded_port", guest: 2222, host: 22
  config.vm.network "forwarded_port", guest: 8080, host: 80

  config.vm.provision "shell", path: "setup_web_server.sh"
end
