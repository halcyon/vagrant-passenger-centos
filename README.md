Vagrant Passenger Centos
========================

Requirements:
*  VirtualBox 4.0.4 or higher
*  Ruby 1.9.2
*  Vagrant

Steps:
1.  vagrant up

2.  cd data/railsapp

3.  rails new . --skip-git 

4.  rails generate scaffold Post name:string title:string content:text

5.  rake db:migrate RAILS_ENV=production


Let's get crazy:

1.  This is a list item with two paragraphs. Lorem ipsum dolor
    sit amet, consectetuer adipiscing elit. Aliquam hendrerit
    mi posuere lectus.

    Vestibulum enim wisi, viverra nec, fringilla in, laoreet
    vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
    sit amet velit.

2.  Suspendisse id sem consectetuer libero luctus adipiscing.

What about some code **in** a list? That's insane, right?

1. In Ruby you can map like this:

        ['a', 'b'].map { |x| x.uppercase }

2. In Rails, you can do a shortcut:

        ['a', 'b'].map(&:uppercase)

