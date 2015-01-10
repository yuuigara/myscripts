#!/bin/bash

# required
if [ `whoami` != "root" ]; then
    echo "this script should be executed by root user."
    exit 1
fi

# package installation
yum install -y git gcc make readline-devel openssl-devel

# rbenv installation
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
mkdir rbenv/{shims,versions}
chgrp -R wheel rbenv
chmod -R g+rwxXs rbenv
mkdir /usr/local/rbenv/plugins
cd /usr/local/rbenv/plugins

# ruby-build installation
git clone git://github.com/sstephenson/ruby-build.git
chgrp -R wheel ruby-build
chmod -R g+rwxs ruby-build

# add settings to profile
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile
echo 'eval "$(rbenv init -)"' >> /etc/profile

source /etc/profile

ruby_version=$(rbenv install -l | egrep "2\.0\.0\-p" | tail -1)
rbenv install $ruby_version && rbenv global $ruby_version
ruby -v

gem install bundler foreman
rbenv rehash
