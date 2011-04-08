#Vagrant Passenger Centos#
Automated build of environment running CentOS 5.5 with Phusion Passenger to run Rails Applications

#Requirements#
- VirtualBox 4.0.4 or higher
- Ruby 1.9.2
- Vagrant
- Rails 3.0.6

#Create a rails app#
1.  vagrant up
2.  cd data/railsapp
3.  rails new . --skip-git 
4.  rails generate scaffold Post name:string title:string content:text
5.  rake db:migrate RAILS_ENV=production
6.  go to http://localhost:8080/rails/posts[http://localhost:8080/rails/posts]
