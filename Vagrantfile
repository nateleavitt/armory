# -*- mode: ruby -*-
# # vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "figr-service" do |v|
    v.vm.provider "docker" do |d|
      d.build_dir = "."
      d.ports = ["4567:4567"]
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
    end
  end

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
