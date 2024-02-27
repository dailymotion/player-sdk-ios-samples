#!/usr/bin/env bash

set -e
set -x
git config --global user.name "Dailymotion Dev Bot"
git config --global user.email "bitrise@dailymotion.com"
(cd $CI_MAIN_SDK_REPO_PATH; bundle install)