#!/bin/bash

# generateDocs.sh
# Use the jazzy command line tool to create HTML Documentation from javadoc style comments in code

if ! [ -x "$(command -v jazzy)" ]
then
  echo "Error: jazzy is not installed. To install jazzy execute: sudo gem install jazzy" >&2
  exit 1
fi

basedir=$(dirname $0)
cd $basedir/..
jazzy --output Documentation --module GenericApp --clean Documentation --author E-Post --author_url https://www.epost.de --copyright "Deutsche Post E-Post Development GmbH" --min-acl internal --skip-undocumented
# jazzy --output Documentation --clean basedir --exclude Pods --swift-version 3 --author E-Post --author_url https://www.epost.de --copyright "Deutsche Post E-Post Development GmbH" --readme ../README.md --min-acl internal --no-skip-undocumented

# --source-directory GenericApp
