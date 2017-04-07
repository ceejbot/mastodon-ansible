#!/bin/bash

cd {{install_dir}}/live
RAILS_ENV=production /usr/local/bin/bundle exec rake mastodon:push:refresh
