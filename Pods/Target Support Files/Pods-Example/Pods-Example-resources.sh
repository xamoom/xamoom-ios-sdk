#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY="$(cd "${1%/*}" && pwd)"
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset/angleRight.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset/car.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset/android.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset/apple.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset/calender.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset/contact.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset/directional.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset/ebook.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset/Email.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset/facebook.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset/flickr.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset/google.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset/itunes.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset/linkedin.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset/phone.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset/Shop32.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset/soundcloud.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset/spotify.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset/twitter.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset/web.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset/wikipedia.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset/windows.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset/youtube.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset/marker 2.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset/openextern.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset/page.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset/pausebutton.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset/playbutton.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset/videoPlay.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets"
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset"
  install_resource "${BUILT_PRODUCTS_DIR}/Assets.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset/angleRight.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset/car.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset/android.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset/apple.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset/calender.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset/contact.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset/directional.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset/ebook.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset/Email.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset/facebook.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset/flickr.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset/google.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset/itunes.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset/linkedin.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset/phone.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset/Shop32.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset/soundcloud.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset/spotify.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset/twitter.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset/web.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset/wikipedia.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset/windows.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset/youtube.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset/marker 2.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset/openextern.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset/page.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset/pausebutton.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset/playbutton.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset/Contents.json"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset/videoPlay.pdf"
  install_resource "../XamoomSDK/Assets/Images.xcassets"
  install_resource "../XamoomSDK/Assets/Images.xcassets/angleRight.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/car.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/android.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/apple.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/cal.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/contact.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/directional.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/ebook.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/email.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/facebook.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/flickr.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/google.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/itunes.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/linkedin.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/phone.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/shop.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/soundcloud.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/spotify.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/twitter.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/web.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/wikipedia.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/windows.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/contentblock icons/youtube.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/mappoint.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/openextern.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/page.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/pausebutton.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/playbutton.imageset"
  install_resource "../XamoomSDK/Assets/Images.xcassets/videoPlay.imageset"
  install_resource "${BUILT_PRODUCTS_DIR}/Assets.bundle"
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
