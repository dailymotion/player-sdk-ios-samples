#!/usr/bin/env bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail

appcenter_secret=""
case ${{inputs.channel_type}} in
stable)
appcenter_secret=$APP_CENTER_SECRET_PROD
;;
beta)
appcenter_secret=$APP_CENTER_SECRET_BETA
;;
alpha)
appcenter_secret=$APP_CENTER_SECRET_ALPHA
;;
*)
echo -n "Unknown release channel_type" ; exit 1
;;
esac
echo ${#appcenter_secret}

sed -i '' -e "s/<<AppCenterSecret>>/${appcenter_secret}/g" ${CI_MAIN_REPO_PATH}/DailymotionPlayerSample/AppDelegate.swift
echo "AppDelegate secret replaced"
sed -i '' -e "s/AppCenterSecretPLIST/appcenter-${appcenter_secret}/g" ${CI_MAIN_REPO_PATH}/DailymotionPlayerSample/Info.plist
echo "Info.plist secret replaced"