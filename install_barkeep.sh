#!/bin/bash

source ~/.profile
gem install therubyracer -v 0.12.1
git clone -b oauth2 https://github.com/jpodeszwik/barkeep.git ~/barkeep
sed -i 's/0.10.1/0.12.1/g' ~barkeep/barkeep/Gemfile.lock
cd ~/barkeep && bundle install && rbenv rehash
