sed -i '' -e "s/<<AppCenterSecret>>/${APPCENTER_API_TOKEN}/g" ${CI_MAIN_REPO_PATH}/DailymotionPlayerSample/AppDelegate.swift
echo "AppDelegate secret replaced"
sed -i '' -e "s/AppCenterSecretPLIST/appcenter-${APPCENTER_API_TOKEN}/g" ${CI_MAIN_REPO_PATH}/DailymotionPlayerSample/Info.plist
echo "Info.plist secret replaced"