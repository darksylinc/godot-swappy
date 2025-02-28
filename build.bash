#! /bin/bash

SPECIFIC_REVISION="1198bb06b041e2df5d42cc5cf18fac81fcefa03f"

if [ -z "$ANDROID_HOME" ]; then
    echo "You must set ANDROID_HOME environment variable. See README."
fi
if [ -z "$JAVA_HOME" ]; then
    echo "You must set JAVA_HOME environment variable. See README."
fi

mkdir -p build

pushd build

echo "Setting up Repo"
repo init -u https://android.googlesource.com/platform/manifest -b android-games-sdk || exit $?
repo sync -c -j8 gamesdk || exit $?
repo sync -c -j8 external/modp_b64 external/googletest external/nanopb-c external/protobuf external/StatsD tools/repohooks || exit $?
repo sync -c -j8 prebuilts/cmake/linux-x86 prebuilts/cmake/windows-x86 prebuilts/cmake/darwin-x86 || exit $?

echo "Checking out the specific revision."
cd gamesdk
git checkout ${SPECIFIC_REVISION} || exit $?
cp ../../local.properties local.properties || exit $?
./gradlew packageLocalZip -Plibraries=swappy -PpackageName=local || exit $?

popd