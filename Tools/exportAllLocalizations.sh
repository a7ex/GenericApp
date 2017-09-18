#!/bin/sh

#  exportAllLocalizations.sh

# Export all localizedString occurrences to the folder 'newTranslations'
# on the current users desktop
# It will still read existing translations in first and create the new files
# according to the translations found in the existing localizable.strings files

basedir=$(dirname $0)
cd "$basedir"
toolsDirectory=$(pwd)
cd ..
projectDir=$(pwd)

translationFilesDir=$HOME/Desktop/newTranslations
mkdir -p "$translationFilesDir"
cd "$translationFilesDir"

"$toolsDirectory/gatherLocalizationStrings.pl" "$projectDir/GenericApp"
