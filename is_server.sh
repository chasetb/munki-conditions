#!/bin/sh
# This is a bash conditional script which outputs if a Mac OS machine has the 'Server.app' app installed.
# Please note you can use the --configured switch to determine if it has been setup or not.
# Full credit: https://groups.google.com/forum/#!msg/munki-dev/3JSqE_3dFgY/UIj8ZanFuF8J

# Read the location of the ManagedInstallDir from ManagedInstall.plist
managedinstalldir="$(defaults read /Library/Preferences/ManagedInstalls ManagedInstallDir)"
# Make sure we're outputting our information to "ConditionalItems.plist" 
# (plist is left off since defaults requires this)
plist_loc="$managedinstalldir/ConditionalItems"

if $(serverinfo --productname &>/dev/null)
then 
    defaults write "$plist_loc" "is_server" -bool TRUE;
else 
    defaults write "$plist_loc" "is_server" -bool FALSE;
fi

# CRITICAL! Since 'defaults' outputs a binary plist, we need to ensure that munki can read it by 
# converting it to xml
plutil -convert xml1 "$plist_loc".plist

exit 0