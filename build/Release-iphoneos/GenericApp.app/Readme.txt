Here are authoring tools

- generateDocs.sh
    This shell script uses the jazzy command line tool to generate documentation files in html format for all classes and methods, which have javadoc style comments.
    The generated html files are output to the folder "Documentation"

- gatherLocalizationStrings.pl
    This perl script goes through all class files and gather occurrences of LocalizedString() calls in order to generate or update the localizable.strings files in the project.
    It does never overwrite translates which are already present. It does also not change the ordering of the strings in the file. For strings which appear more than once in the code, but have different "comments" all differing comments are written into a singel line, so that all occurrences of a given string can be found.
    It has three sections everythging until the MARK /* --------- missing translations: -------------- */ are translations, which already existed, and where only the comments needed to be updated. After that mark all strings, which are new are listed (-> The ones, which still need to be tranlated). In the section marked with the comment: /* --------- orphaned translations: -------------- */ are strings, which were in the localizable.stirngs file, but where not found in code. Most probably they were removed.
    Note, that it does not process any other localizations (storyboard or Info.plist etc.). We avoid those in this project. All user visible strings are set in code, so that the only file we care for concerning localization is the localizable.strings file. The drawback is, that ALL user visible strings must have an outlet so that their content can be set in code (since that is anyway most of the time the case, it is not a big issue)

- exportAllLocalizations.sh
    This shell scripts just creates the directory "newTranslations" on your desktop and calls gatherLocalizationStrings.pl to create the localizable files in that folder instead of updating the localizable.strings files in your project (if you want to compare "before and after")

- updateAllLocalizations.sh
    Update all localizedString files IN PLACE. This will change the current translations! It will read existing translations in first and update the files according to the translations found in the existing localizable.strings files

# Afterwards you can use git to see the changes


In order to run tests from the commandline and convert the test results from OCUnit format into JUnit format, you need to install the tool ocunit2junit somewhere in your PATH and run the following command from within the project folder:

xcodebuild clean test -workspace GenericApp.xcworkspace -scheme "GenericApp" -destination "platform=iOS Simulator,OS=latest,name=iPhone 7" 2>&1 | ocunit2junit
