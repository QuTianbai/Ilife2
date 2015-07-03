if [[ -z ${SKIP_OBJCLEAN} || ${SKIP_OBJCLEAN} != 1 ]]; then
if [[ -d "${LOCAL_APPS_DIR}/Objective-Clean.app" ]]; then
#"${LOCAL_APPS_DIR}"/Objective-Clean.app/Contents/Resources/ObjClean.app/Contents/MacOS/ObjClean "${SRCROOT}"?CH,!Tests
"${LOCAL_APPS_DIR}"/Objective-Clean.app/Contents/Resources/ObjClean.app/Contents/MacOS/ObjClean "${SRCROOT}"?!Vendor,!Resources,!Tests,!External
#else
#echo "warning: You have to install and set up Objective-Clean to use its features!"
fi
fi