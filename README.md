Vagrant Passenger Centos
========================
* VirtualBox 4.0.4 or higher
* Ruby 1.9.2
* Vagrant

1. vagrant up
1. cd data/railsapp
1. rails new . --skip-git 
1. rails generate scaffold Post name:string title:string content:text
1. rake db:migrate RAILS_ENV=production
