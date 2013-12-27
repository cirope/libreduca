VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.host_name = 'libreduca.com'

  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.provision :shell, path: 'puppet/tools/install.sh'

  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Libreduca precise64'
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end
end
