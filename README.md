Vagrant Passenger Centos
========================
*  VirtualBox 4.0.4 or higher
*  Ruby 1.9.2
*  Vagrant

1. vagrant up
2. cd data/railsapp
3. rails new . --skip-git 
4. rails generate scaffold Post name:string title:string content:text
5. rake db:migrate RAILS_ENV=production
