#!/bin/bash

source ~/.profile
gem install therubyracer  -v '0.10.1'
git clone git://github.com/ooyala/barkeep.git ~/barkeep
cd ~/barkeep && bundle install && rbenv rehash
