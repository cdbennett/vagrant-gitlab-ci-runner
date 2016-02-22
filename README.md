# Gitlab CI Runner in Vagrant

Gitlab CI Docker runner in Vagrant. Provisioned by Ansible.

- author: Ondrej Sika <ondrej@ondrejsika.com>
- license: [MIT](https://ondrejsika.com/license/mit.txt)


## Install

Installation is super easy. Replace the variables with your config.

```
git clone git@github.com:ondrejsika/vagrant-gitlab-ci-runner.git
cd vagrant-gitlab-ci-runner
vagrant up --no-provision
url=https://gitlab.com/ci token=998e68db76331130c66bc66301751f name=ci-3 vagrant provision
```

