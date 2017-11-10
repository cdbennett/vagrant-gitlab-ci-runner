#!/bin/sh
# Usage: provision.sh

set -e  # exit on command failure
enable_info_logging=1
enable_debug_logging=0

main() {
    apt-get update
    apt-get purge -y nano
    apt-get install -y \
        vim \
        curl

    if [ "x$(type -t docker)" = "xfile" ]; then
        log_info "Docker already installed, skipping"
        # The Docker convenience install script complains
        # if it's already installed, and does unnecessary work.
        # Skip it.
    else
        log_info "Installing Docker"
        curl -sSL https://get.docker.com/ | sh
    fi

    cat > /etc/apt/preferences.d/pin-gitlab-runner.pref <<END
Explanation: Prefer GitLab provided packages over the Debian native ones
Package: gitlab-runner
Pin: origin packages.gitlab.com
Pin-Priority: 1001
END
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash
    apt-get install -y gitlab-runner

    [ -n "$GITLAB_URL" ] || die "GITLAB_URL not set"
    [ -n "$GITLAB_RUNNER_TOKEN" ] || die "GITLAB_RUNNER_TOKEN not set"
    [ -n "$GITLAB_RUNNER_NAME" ] || die "GITLAB_RUNNER_NAME not set"
    gitlab-runner register \
        --non-interactive \
        --url "$GITLAB_URL" \
        --registration-token "$GITLAB_RUNNER_TOKEN" \
        --name "$GITLAB_RUNNER_NAME" \
        --tag-list 'docker linux virtualized' \
        --executor docker --docker-image debian:9
}

log_info() {
    if [ "x$enable_info_logging" = "x1" ]; then
        echo "$1"
    fi
}

log_debug() {
    if [ "x$enable_debug_logging" = "x1" ]; then
        echo "$1"
    fi
}

die() {
    echo "$1" >&2
    exit 1
}

main "$@"
