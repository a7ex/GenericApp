#!/bin/sh

#  exportAllLocalizations.sh
#  MovingLab
#
#  Created by Alex da Franca on 18.07.17.
#  Copyright © 2017 apprime. All rights reserved.

# Update all localizedString files IN PLACE
# This will change the current translations!
# It will read existing translations in first and update the files
# according to the translations found in the existing localizable.strings files

# Afterwards you can use git to see the changes

basedir=$(dirname $0)
cd "$basedir"
toolsDirectory=$(pwd)
cd ..
projectDir=$(pwd)
cd MovingLab

"$toolsDirectory/gatherLocalizationStrings.pl" "$projectDir/GenericApp"
