#!/bin/bash

apt-get update
apt-get install curl

apt-get install -y git # required for gemspec

apt-get install -y wkhtmltopdf # This extension is used to translate HTML to PDF documents

apt-get install -y postgresql
apt-get install -y libpq-dev # Requires libpg-dev for pg gem
apt-get install -y ruby-dev zlib1g-dev liblzma-dev # some stuff for nokogiri

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash
source /etc/profile.d/rvm.sh
rvm install 2.3.1
gem install bundler

apt-get -y autoremove
# cd /vagrant && bundle
