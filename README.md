## ansible for mastodon

Install [Mastodon](https://github.com/Tootsuite/mastodon) on Ubuntu Trusty with upstart instead of anything more recent and [insert muttering here].

A work in progress as I make this more like a typical ansible role instead of a set of one-off playbooks. Seems to work just fine (I'm using this for my own instance, at least).

1. Clone this repo. Edit the [vars.yml](vars.yml) file.
1. Register a domain name. Buy a cert for it.
1. Spin up Ubuntu Trusty 14.04 on AWS & point DNS at the instance. Don't bother making user accounts or anything; only somebody with your key should be able to ssh in. Add security group rules allowing https from anywhere, or maybe http if you want to redirect.
1. Make an EBS volume or raid up some instance stores and mount them on `{{install_dir}}`, owned by ubuntu.
1. Clone this repo.
1. Edit the `inventory` file to replace the hostname with your name. This is just to make running the playbooks easier.
1. Edit the [vars.yml](vars.yml) file.
1. Note that I have assumed your cert files are named `yourhost.tld.pem` and `yourhost.tld.key`, which they might not be. Edit [host-setup.yml](host-setup.yml) if not.
1. Run `ansible-playbook -i inventory host-setup.yml`. You should now have a host with all required dependencies installed.
1. you might get ruby 2.3.3 instead of 2.3.1 in which case you should just edit the Gemfile.
1. Open up `templates/env.production`. Edit. Set up any implied required external services, like S3 buckets & a mailer. This will take you a bit. Have [the Mastodon production readme](https://github.com/Tootsuite/mastodon/blob/master/docs/Running-Mastodon/Production-guide.md) up while you do this.
1. NOTE that you need to replace `mastodon` with `ubuntu` in the postgres setup. This still needs to be done by hand. (Sorry!)
1. Run `ansible-playbook -i inventory mastodon.yml`. This does initial checkout & db creation.
1. Run `ansible-playbook -i inventory services.yml`. This sets up upstart services & the nginx config.

The ansible plays set up the required cron jobs for you. They also create a handy script `scripts/checkout.sh` to pull source, run migrations, and restart all services for updating.

## BUGS

* Postgres is still on the default volume! Argh.
* No backups. Argh.
* Need to write handlers so we stop/start only when the files change.
* Should use rbenv to get ruby 2.3.1 instead of ruby 2.3.3.

## LICENCE

ISC. Copy and edit at will!
