# Deployment with Openshift

## Preparation

Prepare your machine for deployment with Openshift:

    gem install rhc

    rhc setup


## Setup

Create an application with ruby and mysql on your Openshift server:

    rhc -ahitobito app create -gmedium ruby-2.0 mysql-5.5 --no-git

This creates an application named 'hitobito' in a medium sized gear.

These additional cartridges are required:

cron:

    rhc -ahitobito cartridge add cron

memcached:

    rhc -ahitobito cartridge add http://cartreflect-claytondev.rhcloud.com/github/puzzle/openshift-memcached-cartridge

sphinx:

    rhc -ahitobito cartridge add http://cartreflect-claytondev.rhcloud.com/github/puzzle/openshift-sphinx-cartridge


Finally, define all environment variables defined in the main hitobito README as required for Openshift.


## Deployment

Put hitobito core and all desired wagons in the same parent directory. Then package the application with

    hitobito/.openshift/bin/binary-package.sh

Then Deploy the package:

    rhc -ahitobito app deploy deployment.tar.gz


## Intraction

Login with SSH to your application server:

    rhc -ahitobito ssh

Tail all application logs:

    rhc -ahitobito tail

On the server, opening a Rails console:

    cd app-root/repo
    ruby_context "rails c"


## More

General information for deploying Ruby on Rails application in Openshift:

https://developers.openshift.com/en/ruby-getting-started.html

For information about .openshift directory, consult the documentation:

http://openshift.github.io/documentation/oo_user_guide.html#the-openshift-directory


## Troubleshooting

If Passenger reports "You have already activated rack 1.5.2, but your Gemfile requires rack 1.6.4.",
running `gem install rake` in the app root directory should help (see 
https://bugzilla.redhat.com/show_bug.cgi?id=1184179)
