# -*- mode: ruby -*-
# # vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "figr-service" do |v|
    v.vm.provider "docker" do |d|
      # d.image = "dockerfile/redis"
      d.build_dir = "."
      # d.volumes = ["/var/docker/redis:/data"]
      d.ports = ["4567:4567"]
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
    end
  end

  # config.vm.define "elasticsearch" do |v|
  #   v.vm.provider "docker" do |d|
  #     d.image = "dockerfile/elasticsearch"
  #     d.ports = ["9200:9200"]
  #     d.vagrant_vagrantfile = "./Vagrantfile.proxy"
  #   end
  # end

  # config.vm.define "postgres" do |v|
  #   v.vm.provider "docker" do |d|
  #     d.image = "paintedfox/postgresql"
  #     d.volumes = ["/var/docker/postgresql:/data"]
  #     d.ports = ["5432:5432"]
  #     d.env = {
  #       USER: "root",
  #       PASS: "abcdEF123456",
  #       DB: "root"
  #     }
  #     d.vagrant_vagrantfile = "./Vagrantfile.proxy"
  #   end
  # end

end  
