Vagrant Passenger Centos
========================
*  VirtualBox 4.0.4 or higher
*  Ruby 1.9.2
*  Vagrant

. vagrant up
. cd data/railsapp
. rails new . --skip-git 
. rails generate scaffold Post name:string title:string content:text
. rake db:migrate RAILS_ENV=production
