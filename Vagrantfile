Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
apt-get update
apt-get install -y tmux vim
SHELL

  config.vm.define "ff" do |ff|
    ff.vm.box = "bento/ubuntu-20.04"
    ff.vm.box_check_update = false
    ff.vm.hostname = "TESTING-NODE1"
    ff.vm.network "private_network", ip: "10.10.100.11"
    
    ff.vm.provider "virtualbox" do |vb|
      vb.name = "TESTING-NODE1"
      vb.memory = "8192"
      vb.cpus = 4
    end
  end

  config.vm.define "ss" do |ss|
    ss.vm.box = "bento/ubuntu-20.04"
    ss.vm.box_check_update = false
    ss.vm.hostname = "TESTING-NODE2"
    ss.vm.network "private_network", ip: "10.10.100.13"
    
    ss.vm.provider "virtualbox" do |vb|
      vb.name = "TESTING-NODE2"
      vb.memory = "8192"
      vb.cpus = 4
    end
  end

  config.vm.define "ans" do |ans|
    ans.vm.box = "bento/ubuntu-20.04"
    ans.vm.box_check_update = false
    ans.vm.hostname = "ans-host"
    ans.vm.network "private_network", ip: "10.10.100.3"
    ans.vm.provision "shell", inline: <<-SHELL
apt-get update
apt-get install -y ansible
SHELL

    ans.vm.provider "virtualbox" do |vb|
      vb.name = "ans-host"
      vb.memory = "8192"
      vb.cpus = 4
    end
  end
end
