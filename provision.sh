#! /bin/bash

apt-get update

# needed to use github as a source of mix packages
apt-get install -y git

# This extension is used to translate HTML to PDF documents
apt-get install -y wkhtmltopdf

# Install postgres
apt-get install -y postgresql
apt-get install -y libpq-dev # Requires libpg-dev for pg gem

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

echo "export PGHOST=localhost" | tee -a /home/vagrant/.profile
echo "export PGUSER=postgres" | tee -a /home/vagrant/.profile
echo "export PGPASSWORD=postgres" | tee -a /home/vagrant/.profile

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash
source /etc/profile.d/rvm.sh
rvm install 2.3.3
gem install bundler

apt-get -y autoremove

# Install the Elixir and Erlang languages as required.
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y erlang
apt-get install esl-erlang
apt-get install -y elixir
