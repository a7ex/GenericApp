#!/usr/bin/perl -w
#
# gatherLocalizationStrings - gatherLocalizationStrings.pl
#
# (C)2015 Alex da Franca (http://www.farbflash.de)
#
# Release
# History : v1.0

################# copy and paste example

# projectDir="/Users/alex/Work/iOSApp/XcodeProject/myApp"
# "$projectDir/Tools/gatherLocalizationStrings.pl" "$projectDir/app"

# If you call the above two lines while being in the directory with the corresponding de.lproj, at-de.lproj etc.. directories, this script will replace the existing translation files
# if you call the lines from another directory then new files will be generated in the current working directory, which you then can compare to the strings files in the project
# and apply the changes "manually"

# So are the calls for the two different options:

# 1.) direct replace:
# projectDir="$HOME/Work/iOSApp/XcodeProject/myApp"
# cd "$projectDir/app"
# "$projectDir/Tools/gatherLocalizationStrings.pl" "$projectDir/app"

# 2.) leave originals untouched:
# translationFilesDir=$HOME/Desktop/newTranslations
# mkdir -p "$translationFilesDir"
# cd "$translationFilesDir"
# projectDir="$HOME/Work/iOSApp/XcodeProject/myApp"
# "$projectDir/Tools/gatherLocalizationStrings.pl" "$projectDir/ap"
#### now the new files are on your desktop in the folder "newTranslations"
#################


##########################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please feed useful changes back to http://www.farbflash.de.
#
# For help on configuration or installation see the
# README file or the POD documentation at the end of
# this file.
##########################################


##################### default values:
$verbose = 0;

##################### parse parameters:
&parseCLI;



##################### begin script #####################

use File::Find;
use File::Basename;
use Cwd;
use Cwd 'abs_path';

$| = 1;  # so we can see it run

############################### define variables ################################

# just a few variables for the statistics:
my $totalCountSwift = 0;
my $totalCountSimpleSwift = 0;

my $totalCountC = 0;
my $totalCountSimpleC = 0;

my $allMatches = 0;
my $duplicateMatches = 0;

# array with files to skip
my @skipFiles = ();

# array with folders to process
my @includeFolders = ();

# hashes to store the data, which will be written
my %localizedStrings;
my %oldTranslations;

my $currentCWD = cwd();

my $currentIncludeFolder;


############################### start action ################################

if (@ARGV) {
    push(@includeFolders, @ARGV);
}

if (scalar @includeFolders == 0) {
    push(@includeFolders, cwd());
}

# go through all files in all supplied folders and gather program arguments (such as ignore files, etc.):
for $dir (@includeFolders) {
    $currentIncludeFolder = $dir;
    $currentIncludeFolder .= "/" if (not $currentIncludeFolder =~ /\/$/ );
    find(\&gatherProgramArgumentsFromFile, $dir);
}

# go through all files in all supplied folders and gather LocalizedString() occurrences:
for $dir (@includeFolders) {
    $currentIncludeFolder = $dir;
    $currentIncludeFolder .= "/" if (not $currentIncludeFolder =~ /\/$/ );
    find(\&process_file, $dir);
}

# go through all files in all supplied folders and gather existing translations:
for $dir (@includeFolders) {
    $currentIncludeFolder = $dir;
    $currentIncludeFolder .= "/" if (not $currentIncludeFolder =~ /\/$/ );
    print "processing directory: $dir\n\n" if $verbose;
    find(\&write_new_translations, $dir);
}

$uniqueStringsCount = $allMatches -  $duplicateMatches;
print "\n---------------------------------------------\nStatistics:\n";
print "Number of matches found in swift files: $totalCountSwift (simple search: $totalCountSimpleSwift)\n";
print "Number of matches found in C files: $totalCountC (simple search: $totalCountSimpleC)\n";
print "Number of overall matches: $allMatches, Duplicates: $duplicateMatches, Unique strings: $uniqueStringsCount\n";


@allKeys = keys(%localizedStrings);
$size = $#allKeys + 1;
print "There is a difference between the gathered strings ($size) and the unique string count ($uniqueStringsCount)!\n" if $size ne $uniqueStringsCount;

sub gatherProgramArgumentsFromFile {
    my $filepath = $_;
    my $fullpath = cwd() . "/" . $filepath;
    if ($filepath =~ /gatherLocalizedStringsSettings.txt$/i) {
        (open(DATEI, "<$filepath")) or die "Unable to open file $filepath";
        print "Reading program settings file: $fullpath\n" if $verbose;
        my $currentArray;
        while (my $zeile = <DATEI>) {
            my $withoutComments = $zeile;
            $withoutComments =~ s/\s*\/\*(.*?)\*\/\s*/ /gis;
            $withoutComments =~ s/\s*\/\/(.*)$//gis;
            if ($withoutComments =~ /^\s*\[([^\]]+)\]\s*$/i) {
                my $sectionName = $1;
                if ($sectionName eq "exclude") {
                    print "In exclude section:\n" if $verbose;
                    $currentArray = \@skipFiles;
                }
                elsif ($sectionName eq "folders") {
                    print "In include section:\n" if $verbose;
                    $currentArray = \@includeFolders;
                }
            }
            else {
                if ($currentArray) {
                    chomp($withoutComments);
                    if ($withoutComments ne "") {
                        my $firstChar = substr $withoutComments, 0, 1;
                        if ($firstChar ne "/") {
                            $withoutComments = $currentIncludeFolder . $withoutComments;
                        }
                        if (!(grep {$_ eq $withoutComments} @$currentArray)) {
                            print "Adding $withoutComments\n" if $verbose;
                            push(@$currentArray, $withoutComments);
                        }
                    }
                }
            }
        }
    }
}

# for each "Localizable.strings" file check missing and orphaned translations and write new file
sub write_new_translations {
    my $filepath = $_;
    my $fullpath = cwd() . "/" . $filepath;
    
    if (grep {$_ eq $fullpath} @skipFiles) { return; }
    
    if ($filepath =~ /Localizable.strings$/i) {
        
        my %orphanedTranslations;
        my %processedTranslations;
        my $parent = basename(dirname(abs_path($filepath)));
        if (! -d "$currentCWD/$parent") {
            print "creating directory: $parent\n" if $verbose;
            mkdir "$currentCWD/$parent";
        }
#        open(OUTPUT, ">$currentCWD/$parent/Localizable.strings") or die "Unable to write file";
        open(OUTPUT, ">$currentCWD/$parent/tmp.strings") or die "Unable to write file";
        
        (open(DATEI, "<$filepath")) or die "Unable to open file $filepath";
        print "Creating new translation file for old translation file: $fullpath\n" if $verbose;
        
        # ugly hardcode, but I always want the following at the top of the files
        print OUTPUT "/* NOTE: The following two pairs are to determine how to mark required or optional form fields\n set the translation fo the ones you do not want to see to an empty string */\n\n";
        
        while (my $zeile = <DATEI>) {
            my $withoutComments = $zeile;
            $withoutComments =~ s/\/\*(.*?)\*\///gis;
            if ($withoutComments =~ /^\s*\"(.+?)\"\s*\=\s*\"(.*?)\";/i) {
                my $translationKey = $1;
                my $translation = $2;
                if (defined($localizedStrings{$translationKey})) {
                    print OUTPUT "/* $localizedStrings{$translationKey} */\n\"$translationKey\" = \"$translation\";\n\n";
                    $processedTranslations{$translationKey} = $translation;
                }
                else {
                    $orphanedTranslations{$translationKey} = $translation;
                }
            }
        }
        print OUTPUT "\n\n\n\n/* --------- missing translations: -------------- */\n\n";
        foreach(keys(%localizedStrings)) {
            my $key = $_;
            my $comment = $localizedStrings{$key};
            if (!defined($processedTranslations{$key})) {
                print OUTPUT "/* $comment */\n\"$key\" = \"$key\";\n\n";
            }
        }
        
        print OUTPUT "\n\n\n\n/* --------- orphaned translations: -------------- */\n\n";
        foreach(keys(%orphanedTranslations)) {
            my $key = $_;
            my $translation = $orphanedTranslations{$key};
            print OUTPUT "\n\"$key\" = \"$translation\";\n";
        }
        close(OUTPUT);
        rename("$currentCWD/$parent/tmp.strings", "$currentCWD/$parent/Localizable.strings");
    }
}

# read all "*.swift" and ".m" files and store the infos found in LocalizedString()
sub process_file {
    my $filepath = $_;
    my $fullpath = cwd() . "/" . $filepath;
    
    if (grep {$_ eq $fullpath} @skipFiles) { return; }
    
    my $isSwiftFile = ($filepath =~ /\.swift$/i);
    my $isCFile = ($filepath =~ /\.m$/i);
    
    if ($isSwiftFile || $isCFile) {
        (open(DATEI, "<$filepath")) or die "Unable to open file $filepath";
        if ($verbose) {
            print "Processing SWIFT file: $fullpath\n" if $isSwiftFile;
            print "Processing OBJ-C file: $fullpath\n" if $isCFile;
        }
        my $cntAll = 0;
        my $cntSimple = 0;
        my $mlComment = 0;
        while (my $zeile = <DATEI>) {
            $zeile =~ s/\/\/.+//gi;
            $zeile =~ s/\/\*.+?\*\///gi;
            if ($mlComment eq 1) {
                if ($zeile =~ s/.*?\*\///gi) {
                    $mlComment = 0;
                }
                else {
                    next;
                }
            }
            else {
                if ($zeile =~ s/\/\*.*?//gi) {
                    $mlComment = 1;
                }
            }
            if ($isSwiftFile) {
                while ($zeile =~ /LocalizedString\(\"(.+?)\",[\s|\n]*comment:\s*\"(.*?)\"\)/g) {
                    $cntAll++;
                    add_translation_key($1, $2, $filepath);
                }
            }
            else {
                while ($zeile =~ /LocalizedString\(\@\"(.+?)\",[\s|\n]*\@\"(.*?)\"\)/gis) {
                    $cntAll++;
                    add_translation_key($1, $2, $filepath);
                }
            }
            # now to double check, whether we got all occurrences of LocalizedString, we do a simple cross check
            # regexp search without
            while ($zeile =~ /LocalizedString\(/gs) {
                $cntSimple++;
            }
        }
        
        print "\nWARNING: different matchcount in file: $fullpath\n\n" if ($cntAll ne $cntSimple);
        
        if ($isSwiftFile) {
            $totalCountSwift += $cntAll;
            $totalCountSimpleSwift += $cntSimple;
        }
        else {
            $totalCountSwift += $cntAll;
            $totalCountSimpleSwift += $cntSimple;
        }
        
        close(DATEI);
    }
}

sub add_translation_key {
    local($translationKey, $translationComment, $fullpath)= @_;
    if (length($translationComment) < 1) {
        $translationComment = "- Comment missing in $fullpath -";
    }
    $allMatches++;
    if (my $comment = $localizedStrings{$translationKey}) {
        if (!($comment =~ /\Q$translationComment\E/i)) {
            $localizedStrings{$translationKey} = "$comment\n $translationComment";
        }
        $duplicateMatches++;
    }
    else {
        $localizedStrings{$translationKey} = $translationComment;
    }
}



##################### end script #####################


# ------ command line parameter parsing using Getopt::Long module
# ------ in the hash provided to GetOptions specify the recognized switches
# ------ any not specified switch aborts the programm and shows the help
# ------ if a = is specified a type can be specified "=s" means the item after the switch is its value

sub parseCLI{
    
    # ------ POD::Usage for nice documentation, help and man page like output (at the end of this script => __END__)
    use Pod::Usage;
    # ------ Getopt::Long to read command line switches in long or short form and call POD::Usage
    use Getopt::Long;
    
    
    # ------ Configure Getopt::Long to handle long options (praefixed by two dashes => --option)
    Getopt::Long::Configure ("bundling");
    
    
    # ------ default values:
    my $man = 0;
    my $help = 0;
    
    # ------ First parse the command line options and fill the default vaariables
    GetOptions ("verbose|v" => \$verbose,
				"help|h|?" => \$help,
				"man" => \$man)
    or pod2usage(2);
    
    # ------ print help or man page and bail (if Getopt::Long found -h -? --help or --man)
    pod2usage(1) if $help;
    pod2usage(-exitstatus => 0, -verbose => 2) if $man;
    
}


__END__

=head1 NAME
 
 gatherLocalizationStrings
 
 Perl script to gather the contents of all occurrences of LocalizedString()
 in all swift (.swift) and objective-C / C / C++ (.m) files
 
 =head1 SYNOPSIS
 
 gatherLocalizationStrings.pl [options] [folder ...]
 
 Options:
 --help, -?, -h    brief help message
 --man             full documentation
 --verbose, -v     output log messages
 
 =head1 OPTIONS
 
 =over 8
 
 =item B<-help>
 
 Print a brief help message and exits.
 
 =item B<-man>
 
 Prints the manual page and exits.
 
 =item B<-verbose>
 
 Output debug/status/log strings while running.
 
 =back
 
 =head1 DESCRIPTION
 
 B<This program> will read all files in the given input folder(s) and
 process all .swift and .m files to find all occurrences of 'LocalizedString()' in the source code.
 It will then gather all keys and create Localizable.strings files for use with LocalizedString().
 It will not list the same key twice, instead they will be combined.
 If two equal keys have different comments, they will be printed in different lines.
 
 It will use any already existing Localizable.strings file and use the translations found there.
 
 Provide a file named: "gatherLocalizedStringsSettings.txt" to read input parameters from file
 As of now it "understands" the following sections:
 [exclude]
 each path in this section will be ignored, also any localizable.strings files, which are read to gather existing translations
 [folders]
 add more folders to the search, instead of specifying them all as arguments
 
 Path names in the settings file can be absolute or relative to the directory which was given as parameter.
 So make sure you use the matching directory as 1st parameter to this program
 
 If you get a warning like:
 WARNING: different matchcount in file: xxx
 It means, that the crosscheck using a simpler regexp for 'LocalizedString' yields a different result, than the more complicated regexp, which expects a proper comment for LocalizedString.
 It may have different reasons. If you open the file and search for LocalizedString you will probably see right away, whats wrong. E.g. a return between the paramaters or a missing comment...
 Speaking of comments: You should anyway ALWAYS write a VERY EXPLANATORY comment for your LocalizedString!
 Keep in mind, that the person who translates the string, very often needs to know the context of the string to translate.
 The only info you can give them is describing the view where the string is and its purpose.
 E.g. "Login screen: label for button to cancel login"
 
 Example for the conrad app:

 projectDir="/Users/alex/Work/myApp/XcodeProject/app"
 "$projectDir/Resources/gatherLocalizationStrings.pl" "$projectDir/appFolder"


 
 =cut
