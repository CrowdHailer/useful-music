#! /bin/bash

apt-get update

# needed to use github as a source of mix packages
apt-get install -y git

# This extension is used to translate HTML to PDF documents
apt-get install -y wkhtmltopdf

# Install postgres
apt-get install -y postgresql

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

apt-get -y autoremove

# Install the Elixir and Erlang languages as required.
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y erlang
apt-get install esl-erlang
apt-get install -y elixir
