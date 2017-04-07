#!/bin/bash

set -e

cd {{install_dir}}/live
git pull
bundle install
yarn install
RAILS_ENV=production bin/bundle exec rails db:migrate
RAILS_ENV=production bin/bundle exec rails assets:precompile

{% for service in services %}
echo "Restarting {{service}}..."
sudo restart {{service}}
{% endfor %}
