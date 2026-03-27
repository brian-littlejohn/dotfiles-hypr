#!/bin/bash
FirefoxProfileDir=~/.mozilla/firefox
MozillaDir=~/.mozilla
FFProfileNames=(Personal IPMTech DOI Admin Media)

if [ ! -d "$MozillaDir" ]; then
    echo "Directory $MozillaDir Does Not Exists."
else
    if [ ! -d "$FirefoxProfileDir" ]; then
        echo "$FirefoxProfileDir does not exist"
    else 
        echo "Firefox Profiles:"
        for profile in "${FFProfileNames[@]}"; do
            echo "Profile: $profile"
        done
    fi
fi