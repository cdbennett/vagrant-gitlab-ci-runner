# Gitlab CI Runner in Vagrant

Gitlab CI Docker runner in Vagrant. Provisioned by shell script.
Using Debian 9 base box.

- author: Ondrej Sika <ondrej@ondrejsika.com>
- author: Colin Bennett <colin@gibibit.com>
- license: [MIT](https://ondrejsika.com/license/mit.txt)


## Install

Installation is super easy. Replace the variables with your config.

```
git clone git@github.com:cdbennett/vagrant-gitlab-ci-runner.git
cd vagrant-gitlab-ci-runner
export GITLAB_URL=http://gitlab.yourdomain.com/
export GITLAB_RUNNER_TOKEN=xxxxxxxxxxxx
export GITLAB_RUNNER_NAME=myrunner
vagrant up
```
