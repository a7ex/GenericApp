# Description of the project

**Name of the App** is a ... <short description of the goal of this app>


## Project tenets
### Sustainability
The App, shall be updated in regular, short intervalls. Therefore much attention shall be given to sustainability: from version to version of iOS, but also from version to version of this App.
### Follow standards and guidelines
The overall strategy is: stick with standards. This can not be stressed enough. It is the key to future proof apps. If we "swim with the flow" the flow will carry us. If we don't, we will need to update the app deeply on each iOS update.

If we use what Cocoa offers and follow Apples guidelines, the App will magically work with the next iOS update and even better: it will automatically be up to date and look modern and fit into the new OS.

Whereas, if we hack into, for example, the look of the NavigationBar, then chances are high that it will break with the next iOS update or at least look old and ancient. If we mimic today the iOS NavigationBar style, then Apple changes the look in an upcoming OS update, our app still looks like the old OS in the new OS. That really looks very bad and reveals the fact, that we did not yet update the app. That will put much pressure on a quick update.

Whereas, if we embrace the tools and guidelines we have. Then we will need few to zero work in order to update for the next iOS. That's one of our goals.

### Simplicity
UI and code shall be simple and follow the standard.

## Project language
We want to use and embrace Swift. Swift was designed and thought off to solve some problems, which can not be solved by Objective-C. Of course, Xcode allows to use both languages side by side and even mix them. But that doesn't mean, that things, which are not possible in Swift, should just be done in Objective-C. ONLY if there is ABSOLUTELY no other solution in Swift (YET).

A good example is runtime introspection and dynamic variable names. It is something you should not do as a good Swift citizen. And thus there is no point in resorting to Objective-C.

If possible Swift classes should not subclass NSObject. Although it is a solution to many things, which you are used to from your Objective-C work, it is nothing which WE want to do in our app.

We want to take full advantage of Swift. Of course, that doesn't mean, that most of the classes, which you subclass from Cocoa aren't subclasses of NSObject. But that is up to Apple to change that over time. Nothing we will need to change on our side, just because we subclass for example UIViewController. One day Apple will port their Cocoa classes to swift and we will be fine. If we build up ourselves on NSObject, we will depend on the "old style". And one day (in the future) will need to adapt our code, when Apple strips support for Objective-C. Or when new technologies will only work with clean Swift code. So to make a long story short: avoid subclassing NSObject. Our Swift classes shall either not subclass anything or subclass other swift classes or cocoa top-level classes. Of course there are exceptions to that rule, especially, when our classes need to interface with Objective-C classes.

## Project structure

The structure is organised in layers.

Basically we have four Layers:

- **Presentation**
- **Process**
- **Application**
- **Data**

Each of the Layer is in its own subfolder.

We use swift modules in two forms:

- Embedded Frameworks in the folder **SwiftModules**
- embedded via the Package Manager [Cocoa Pods](https://cocoapods.org)

CocoaPods are organized as a separate Xcode Project **Pods** in the same Xcode workspace. The Pods project is completely under Cocoa pods control and only one file needs to be edited _manually_: **Podfile** and cocoa pods is managed from the command line (Terminal). You basically only need two commands
````
pod update
````
or

````
pod install
````
after editing the Podfile.

### Starting points

#### <Some Class and a short description and purpose>


### Presentation Layer
This is the complete UI layer. Viewcontrollers, Views, Storyboards and Images

Contents:
- Storyboards (.storyboard and .xib files)
- Viewcontrollers (ViewController subclasses)
- Views (UIView subclasses to provide special UI, UITableViewCell subclasses)
- Images (The images organised in one or more .xcassets folders)
- Localizable.strings

### Application Layer
In this folder are files, which are related to the Business Logic of the App.
The connection between the fronted and the server backend
- Models
- Services
- App State

### Process Layer
E.g. A class to provide App Configuration Values, like fonts, colors, etc. (ConfigValues.swift)
- Managers
- Models
- Helpers
- Cocoa Class Extensions / Categories (All extensions to cocoa classes should go in here)
- Info.plist
- Bridging-Headers

### Data Layer
Classes which provide access to local and remote resources

### Resources
In here are resource files, which provide settings for the Process Layer and the Styleguide, which is a lookup document for the developer, rather than for the app.

### SwiftModules
Encapsulated Code as Swift Framework

- <Name of Swift Module 1>
- <Name of Swift Module 2>

### Tests
Unit- and UITests

- <Projectname>Tests (Unit Tests)
- <Projectname>UITests (UI Tests)

### Tools
Commandline tools for purposes during authoring
- .gitignore
- .swiftlint.yml

- <Tool 1 with short description>
- <Tool 2 with short description>

### Documentation
Automated HTML documenantation created with the CLI tool [Jazzy](https://github.com/realm/jazzy)

### Frameworks

- External (External Frameworks embedded as Git submodules)

- <Framework 1 with short description>
- <Framework 2 with short description>

### Pods
External frameworks managed by Cocoa Pods

- <Pod 1 with short description>
- <Pod 2 with short description>


### Files and folders
While we do NOT work with folder references, we do care for the same structure with the Xcode group and the filesystem. So if you see the groups "Layers" / "PresentationLayer" / "Storyboards" you will find the exact same folder structure in the filesystem.

A similar rule applies to images: we organise all of our images in an xcasset file. While they CAN have different names, than their file names, we want to avoid that, so that our files have the same names as the assets in the Images.xcassets.

## Storyboards

### Structure
We split up the storyboards into separate files. Not only to help the teamwork, but also it is better to work with smaller SB files. (In a "tabbed application", there could be a storyboard file for each single Tab and another one (Main) for shared scenes and login and so on.)
### Constraints and custom values
The general rule for the work with storyboards is: do as few as possible to achieve something, but enough that it will work without issues. That seems silly as a rule, because that's what we always want. But in case of working with storyboards "clean-ness" is a MUST. Especially, when it comes to constraints.

First of all we should try to achieve the goal with as few as possible constraints, with as few as possible custom values. As harder as we try to change as few as possible properties in IB, the more joy we will have for future changes. There is nothing more annoying than too many constraints, which are leftovers from previous "attempts".

That rule applies to all properties, which you set through IB. If any possible use the default values.

Exceptions to that rule are: Scene Identifiers. ALWAYS name the scenes, we do not want unnamed scenes in our storyboards (exception are containers, like UINavigationController etc., although it doesn't "hurt" them to have a meaningful identifier as well).


# Working with the repository / Version Control System

We use [Git](http://git-scm.com) as our version control system.
We use the [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) workflow. For each task, create a feature branch and commit only to this feature branch. When done working on the feature, issue a pull request. The master, develop, hotfix, release and prerelease branches are **NEVER** committed to. They only get updated via merging after issuing a pull request.

In compliance with GIT-Flow we use one feature-/bugfix-branch per ticket. Each commit has the following structure "Ticket#{TicketId} {Short and precise message describing the commit}. If you are working on a ticket with several sub-tickets it sometimes makes sense to group them in one branch which is ok. For the branches the following naming-scheme will be applied:
* Feature-Branches: feature/{TicketId}-short-description-with-dashes-instead-of-spaces
* Bugfix-Branches: feature/{TicketId}-short-description-with-dashes-instead-of-spaces
* Release-Branches: release/{version-number}
* Hotfix-Branches: release/{version-number}

## Commit rules:
* Never push a non working/compiling version to the repository.
* Each commit should refer to a ticket (if no ticket exists, please create one)

## Commit Message Format

Each commit must have a descriptive commit message in the following format:

Ticket#<ticket number> Some descriptive commit message

Example:

Ticket#19834 Implemented barcode scanner, which for now is set to scan only EAN-13 codes)

## Pull Request / Merge Request
As soon as you finish a feature, don't "close the feature" using SourceTrees Gitflow Plugin. SourceTree would merge it into "develop", but our Repository is set up to not allow pushing changes directly to develop. Instead you will create a Pull Request, then the coworkers will review it and accept it or make comments. After at least one acceptance it will be merged by the stash/gitlab. That also means, that you should always before creating a PR, update "develop" before and use Xcode to "Merge branch into...".

Then you merge "develop" into the feature branch you are working on and fix any merge conflicts. That will make sure, that Gitlab will be able to merge into "develop" without merge conflicts (otherwise Gitlab will not merge – there is no conflict resolution in Gitlab).

## Push daily
Another "rule" is to push once a day the branch you are working on. Of course I know, that sometimes that is not possible, when you are in the middle of something and it wouldn't make sense to push a completely "broken" state. So there may be days, where you can not follow that rule, but generally you should aim to push at least once a day. (no maximum limit ;-)

## Discard unnecessary changes
Here's an important "rule". As you might know, just opening a storyboard in Xcode (Interface Builder) will change the storyboard in most cases. That is due to Xcode's lameness of storing meta data in the storyboard document file instead of storing metadata in a separate file. Merging storyboards is not so much fun (the same is true for the project file). Thankfully that has been fixed: the IDs don't change except for the header, which has the ID for the version of Xcode which was used, but still there are many changes to this non-human-readable files, that merge conflicts are tedious.

So whenever you know, that you haven't changed anything in the storyboard please "Discard the changes..." in order to avoid unnecessary merge conflicts.

## Git ignore files

The hidden file **.gitignore** is added to the Xcode Project so that it is available for inspection. You can find it in the **Tools** group.

The cocoa pod directory is deliberately NOT excluded. While there are some discussions around whether or whether not to add Pods to your repo, even the official CocoaPods webpage states: We recommend against adding the Pods directory to your .gitignore. However you should judge for yourself, the pros and cons are mentioned at: https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control

The reason is that we want the app to compile at any given time after a fresh git checkout. Requiring to install cocoa pods after checking out a branch brings a load of problems, up to the point, where you can not compile and run the app anymore, because a cocoapod meanwhile "ran out of business", or the server is down or whatever reason. The main rule is that any checkout of the _develop_ and _master_ branch should compile and run.

## Notes for the different IDEs

### Xcode
Personally I favour the Xcode Git client, as my believe is, that it has more _internal information_ on how to handle properly merge conflicts. Other clients, like SourceTree for example, offer much more functionality, but do not "know" about the _inner workings_ or the Xcode project. Further I prefer the visual merge editor of Xcode over SourceTree. The most critical part of Git versioning in Xcode are internal settings of Xcode and the Storyboards. Therefore we want to split up the storyboards in several different files to avoid merge conflicts with them (Elements in storyboards, have unique IDs, which may differ from machine to machine, therefore external version control tools have a harder time to make a sense of what to merge)


# External/Third Party Libraries (e.g. Cocoa Pods)
We are not against using external frameworks per se, but additional work due to outdated dependencies and therefore the need of rewriting large parts of the app when Apple updates iOS, require us to decide carefully whether the use of an external library is appropriate. Too many dependancies can quickly become a burden.

So, simple things like e.g. an overlay HUD, are most of the times smaller and better tailored to our app, than using external libraries for every little thing.

Very often it also means, that you have much redundant code in your app.

First because the Pods for a very good reason must be written generically and cover many cases, which do not apply to our app. And second because we often can not use (or don't know about) the inside code, which handles a task, which we do handle already as well on our side.

In the case where an external library is the better choice, than "reinventing the wheel", choose carefully, which libraries to choose. Here are some global rules:
* always prefer libraries written in swift
* licenses must be considered
* the last changes to the library must not be too old. Libraries which haven't been updated for more than year are discouraged


# Code of Conduct

# Naming conventions

## Swiftlint
Many of the following naming and coding conventions are automatically checked using the linter [swiftlint](https://github.com/realm/SwiftLint). The settings file for swiftlint is embedded into the Xcode project in the **Tools** Group. Swiftlint must be installed on the system in order for it to run. It will be invoked as "Run Script" **Build Phase** of the target. It expects the swiftlint binary to be installed and available in your shells $PATH. If it is not, the build process will stop with an error. Go to https://github.com/realm/SwiftLint and follow the steps to install the swiftlint command line tool somewhere in your PATH. At the end of each build process swiftlint is invoked and you may then end up with Warnings or even Errors (depending on the swiftlint configuration). Please remove all warnings and errors, which will make sure, that many of the below listed rules are complied.

## File- and Foldernames

File and foldernames shall use only alphanumeric characters, the underscore (_) and the plus (+) characters. No spaces or diacritical characters.

Filenames for class files shall be the name of the class with the corresponding extension (e.g. the swift class Product is defined in file "Product.swift", the objectiveC class OldClass is defined in the files OldClass.h and OldClass.m). Exception to this rule are a few cases, where we have more than one class defined in the same file, like a compound class. In  that case choose some kind of meta name.

Filenames for files, which contain extensions to swift classes shall be suffixed with the term "Extension" (e.g. an Extension to the class "Product" would be named "ProductExtension.swift")

For extensions to objective-C classes (Categories) separate the original classname, which gets extended using a plus sign (+) from a description of the extension (e.g. category to UIView with different app related helper functions could be named "UIView+COAdditions.h" and "UIView+COAdditions.m"

You can interchange the both naming conventions for files with Extensions/Categories as you like.

## Class-, Type-, Function- and Variablenames

Use descriptive names with camel case for classes, methods, variables, etc. Class, Struct, Enum and Constant names should be capitalized, while method names and local variables should start with a lower case letter.

Use only alphanumeric characters and the "_" (underscore / underbar), "-" (dash / minus) and "+" (plus). No diacritical chars, no spaces, unless of course it is an requirement, when the names are exposed to the UI.

For functions and init methods, prefer named parameters for all arguments unless the context is very clear. We try to comply to Apples naming guidelines here, which changed with Swift 3. We want to adopt the Swift 3 style. Include external parameter names if it makes function calls more readable.
```swift
func dateFrom(dateString: String) -> NSDate
func convertPoint(atColumn: Int, inRow: Int) -> CGPoint
func timedAction(afterDelay: NSTimeInterval, perform action: SKAction) -> SKAction!
```
would be called like this:
```swift
dateFrom(dateString: "2014-03-14")
convertPoint(atColumn: 42, inRow: 13)
timedAction(afterDelay: 1.0, perform: someOtherAction)
```
For methods, follow the standard Swift 3 convention of referring to the first parameter with a parameter label, which appended to the method name makes sense:
```swift
class Guideline {
func combine(withIncoming: String, options: Dictionary?) { ... }
func upvote(byAmount: Int) { ... }
}
```
No need to repeat the type of the parameter, as the type is clear in most cases:

so do not do something like:
```swift
func combine(withIncomingString: String) { ... }
```
but rather:
```swift
func combine(withIncoming: String) { ... }
```

# Class Prefixes
Swift types are automatically namespaced by the module that contains them and you should not add a class prefix. If two names from different modules collide you can disambiguate by prefixing the type name with the module name.
```swift
import SomeModule

let myClass = MyModule.UsefulClass()
```

See also Apples [naming guidelines](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1)

# Coding conventions
## Class design
Classes should be declared like the following:
```swift
class ClassName {
    private final var prop1: Int?
    private let prop2 = "Readonly variable"

    private struct Constants {
        struct Alert {
            static let Message = NSLocalizedString("Please enter a name!", comment:"A meaningful comment, which describes to the translator WHERE the string appears and its purpose")
            static let Title = NSLocalizedString("Missing data", comment:"Coding convention example alert: title")
        }
        struct CellIdentifier {
            static let Empty = "EmptyCell"
        }
        struct Margin {
            static let Left = 12
        }
    }

    private final func functionName(param1: String) {
        prop1 = param1
    }

    public func getProp2() -> String {
        informUserAbout(Constants.AlertMessage, title: Constants.AlertTitle)
        return prop2
    }
}
```
* Opening curly brackets appear on the same line separated by a space character. There should be no empty line after the opening curly bracket.
* One whitespace shall appear after commas and colons, but not before.
* Whenever possible leave the type declaration out, when declaring a variable and let Xcode infer the type instead. Declare the variable type only, if necessary.
* Everything should be declared private and final (where possible), unless it should explicitly be accessible (public interface) or overridable.
* Any literals (strings, numbers etc) should be organized in one struct per class, so we do not have **ANY** literals spread somewhere inside the code, but rather everything grouped together in this struct of literals
* Strings which are displayed to the user shall always be passed to the NSLocalizedString() function. NSLocalizedString() shall always use a meaningful comment. When defined, the strings shall also be added to "Localizable.strings".
* Define multiple variables and structures on a single line if they share a common purpose / context.
* Indent getter and setter definitions and property observers.
* Don't add modifiers such as _internal_ when they're already the default. Similarly, don't repeat the access modifier when overriding a method.
* Use `// MARK:`s to categorize methods into functional groupings and protocol implementations.
* There should be exactly one blank line between methods to aid in visual clarity and organization. Whitespace within methods should separate functionality, but often there should probably be new methods.
* Never use spaces between parentheses and their contents.
* Separate binary operands with a single space, but unary operands and casts with none.
* Always use weak references for outlets and use them in a defensive manner in your code (e.g. titleLabel?.text = "some text"  VS. titleLabel.text = "some text")
* Always check for AND handle errors and warnings in a sensible way. In most cases the user should be informed, if the app can not complete a user initiated task, and not just silently fail and leave the user "in the dark" (see: [Error handling](#Error_handling))

## Classes and Structures
### Which ones to use

Remember, structs have [value semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_144). Use structs for things that do not have an identity. An array that contains [a, b, c] is really the same as another array that contains [a, b, c] and they are completely interchangeable. It doesn't matter whether you use the first array or the second, because they represent the exact same thing. That's why arrays are structs.

Classes have [reference semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_145). Use classes for things that do have an identity or a specific life cycle. You would model a person as a class because two person objects are two different things. Just because two people have the same name and birthdate, doesn't mean they are the same person. But the person's birthdate would be a struct because a date of 3 March 1950 is the same as any other date object for 3 March 1950. The date itself doesn't have an identity.

Sometimes, things should be structs but need to conform to AnyObject or are historically modeled as classes already (NSDate, NSSet). Try to follow these guidelines as closely as possible.

## Access Control

All elements (Classes, Structs, Enums, Variables etc.) should _start out_ with their access level set to **private**. Only, if a less strict access level is required, we want to mark the element with the next lower access level (**internal** or **public**). The rule of thumb is: as much as possible shall be **private**.

Everything which can possibly be marked as **final** should be marked so, even if **private** implicitly makes most methods or properties **final** we nonetheless want to explicitly write **final** out in order to make it clear to the reader, that an item is meant to not be subclassed / overridden anymore. This also makes sure, that if future the developer removes the **private** access control modifier, he will not 'forget' to mark the variable or function **final**.

Marking methods and properties as **final** helps the compiler to generate faster execution code.
## Use of Self

For conciseness, avoid using self since Swift does not require it to access an object's properties or invoke its methods.

Use self when required to differentiate between property names and arguments in initializers, and when referencing properties in closure expressions (as required by the compiler):
```swift
class Person {
    private final var name: String
    private final var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age

        let closure = {
            println(self.name)
        }
    }
}
```
## Control Structures

In control structures, like if-else, switch-case, do-while etc. the opening curly brace shall appear on the first line separated by a space, the closing bracket shall appear on its own line. If-clauses do not appear in parentheses.
```swift
if someInteger == 5 {
    prop1 = someInteger
} else {
    prop1 = 0
}

switch someVar {
case 1:
    break
default:
    prop2 = "Default case"
}

for (key, value) in myDict {
    println("The value for \(key) in myDict is \(value)")
}
```

Prefer the _for-in_ style of for loop over the _for-condition-increment_ style.
```swift
for _ in 0..<3 {
    println("Hello three times")
}

for (index, person) in enumerate(attendeeList) {
    println("\(person) is at position#\(index)")
}
```

Instead of:
```swift
for var i = 0; i < 3; i++ {
    println("Hello three times")
}

for var i = 0; i < attendeeList.count; i++ {
    let person = attendeeList[i]
    println("\(person) is at position#\(i)")
}
```

## Comments

When they are needed, use comments to explain why a particular piece of code does something.

Comments must be kept up-to-date or deleted.

Avoid block comments inline with code, as the code should be as self-documenting as possible. Exception: This does not apply to those comments used to generate documentation.

Use `//MARK: -` comments to separate logical blocks in your code files

`//TODO:`, `//FIXME:`, `//WARNING:` and `//ERROR:` comments will be processed in a "run script" build phase, if the run mode is Debug, and will appear in Xcode's Issue Navigator

### Comments for documentation

Public interface should be documented using javadoc style comments above public methods and variables.

Classes, structs and enums should have a javadoc style comment above their declaration, which explains the purpose of the class/struct/enum. An exception to this rule are ViewControllers and their subclasses, unless they are generic ViewControllers for multiple purpose.

Hint: You can use the VVDocumenter Xcode plugin to save typing work. Easiest to is to manage Xcode plugins via the Alcatraz plugin Manager. [Alcatraz](http://alcatraz.io)

## Protocol Conformance

When adding protocol conformance to a class, prefer adding a separate class extension for the protocol methods. This keeps the related methods grouped together with the protocol and can simplify instructions to add a protocol to a class with its associated methods.

Also, don't forget the `//MARK: - ` comment to keep things well-organized!
```swift
class MyViewcontroller: UIViewController {
// class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewcontroller: UITableViewDataSource {
// table view data source methods
}

// MARK: - UIScrollViewDelegate
extension MyViewcontroller: UIScrollViewDelegate {
// scroll view delegate methods
}
```

## Computed Properties

For conciseness, if a computed property is read-only, omit the get clause. The get clause is required only when a set clause is provided. In a set clause use the predefined parameter _newValue_

```swift
var diameter: Double {
    return radius * 2
}

var area: Double {
    get {
        return M_PI * radius * radius
    }
    set {
        radius = sqrt(newValue / M_PI)
    }
}
```

## Closure Expressions

Use trailing closure syntax only if there's a single closure expression parameter at the end of the argument list. Give the closure parameters descriptive names.

```swift
UIView.animateWithDuration(1.0) {
    self.myView.alpha = 0
}

UIView.animateWithDuration(1.0,
    animations: {
        self.myView.alpha = 0
    }, completion: { finished in
        self.myView.removeFromSuperview()
    }
)
```

instead of:
```swift
UIView.animateWithDuration(1.0, animations: {
    self.myView.alpha = 0
})

UIView.animateWithDuration(1.0,
    animations: {
        self.myView.alpha = 0
    }) { completed in
        self.myView.removeFromSuperview()
}
```
For single-expression closures where the context is clear, use implicit returns:
```swift
attendeeList.sort { a, b in
    a > b
}
```

## Types

Always use Swift's native types when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.
```swift
let width = 120.0                                    // Double
let widthString = (width as NSNumber).stringValue    // String
```

instead of:
```swift
let width: NSNumber = 120.0                          // NSNumber
let widthString: NSString = width.stringValue        // NSString
```

Note: the above snippet is just an example. In the above case it is preferable to use Swift's String Interpolation like so:
```swift
let widthString = "\(width)"
```

## Constants

Constants are defined using the _let_ keyword, and variables with the _var_ keyword. Always use _let_ instead of _var_ if the value of the variable will not change.

**Tip:** A good technique is to define everything using let and only change it to var if the compiler complains! We prefer constants over variables for many reasons.

## Optionals

Declare variables and function return types as optional with ? where a nil value is acceptable.

Use implicitly unwrapped types declared with ! only for instance variables that you know will be initialized later before use, such as subviews that will be set up in viewDidLoad.

When accessing an optional value, use optional chaining if the value is only accessed once or if there are many optionals in the chain:
```swift
self.textContainer?.textLabel?.setNeedsDisplay()
```

Use optional binding when it's more convenient to unwrap once and perform multiple operations:
```swift
if let textContainer = self.textContainer {
// do many things with textContainer
}
```

When naming optional variables and properties, avoid naming them like _optionalString_ or _maybeView_ since their optional-ness is already in the type declaration.

For optional binding, shadow the original name when appropriate rather than using names like _unwrappedView_ or _actualLabel_.

```swift
var subview: UIView?
var volume: Double?

// later on...
if let subview = subview,
    let volume = volume {
    // do something with unwrapped subview and volume
}
```

instead of:
```swift
var optionalSubview: UIView?
var volume: Double?

if let unwrappedSubview = optionalSubview {
    if let realVolume = volume {
        // do something with unwrappedSubview and realVolume
    }
}
```

If an if statement unwraps more than one optional, use one line per declaration, instead of declaring more than one variable in the same line.

```swift
if let subview = subview,
    let volume = volume {
    // do something with unwrapped subview and volume
}
```

instead of:
```swift
var optionalSubview: UIView?
var volume: Double?

if let subview = subview, volume = volume {
    // do something with unwrapped subview and volume
}
```
## Struct Initializers

Use the native Swift struct initializers rather than the legacy CGGeometry constructors.

```swift
let bounds = CGRect(x: 40, y: 20, width: 120, height: 80)
let centerPoint = CGPoint(x: 96, y: 42)
```

Instead of:
```swift
let bounds = CGRectMake(40, 20, 120, 80)
let centerPoint = CGPointMake(96, 42)
```

Prefer the struct-scope constants `CGRect.infiniteRect`, `CGRect.nullRect`, etc. over global constants `CGRectInfinite`, `CGRectNull`, etc. For existing variables, you can use the shorter `.zeroRect`.

## Type Inference

Prefer compact code and let the compiler infer the type for a constant or variable, unless you need a specific type other than the default such as CGFloat or Int16.
```swift
let message = "Click the button"
let currentBounds = computeViewBounds()
var names = [String]()
let maximumWidth: CGFloat = 106.5
```
Instead of:
```swift
let message: String = "Click the button"
let currentBounds: CGRect = computeViewBounds()
var names: [String] = []
```
**
NOTE:** Following this guideline means picking descriptive names is even more important than before.

## Semicolons
Swift does not require a semicolon after each statement in your code. They are only required if you wish to combine multiple statements on a single line.

Do not write multiple statements on a single line separated with semicolons.

The only exception to this rule is the _for-conditional-increment_ construct, which requires semicolons. However, alternative _for-in_ constructs should be used where possible.

## Language

Always use English for comments and variable, class, struct and enum names and all code.

Use US English spelling to match Apple's API.
```swift
let color = "red"
```
Instead of:
```swift
let colour = "red"
```
### Error handling

Always check for AND handle errors and warnings in a sensible way. In most cases the user should be informed, if the app can not complete a user initiated task, and not just silently fail and leave the user "in the dark".

# Important rules

## Code Version Control (GIT)

As usual for Versioning Systems: commit often!

Commit messages must be of the following format:

Ticket:#123456 Comments to what changed in this commit. The number of the ticket is the Ticket ID.

We use the Gitflow workflow. It is only allowed to commit and push feature or bugfix branches. Use always feature branches for everything, which is not yet in a live App. Bugfix branches are for bugs fixed for released versions of the app. Create a new feature branch for each feature you work on. The name of the feature branch shall branch the following scheme:

feature/123456-Short-Description-of-feature

Where the number again is the ticket number from the bug tracker.

When committing always make sure, to discard non-relevant changes. Especially, if you see changes to storyboard files or the project file, which you didn't work on. In most cases, these changes were made automatically by Xcode by only opening the storyboard in IB. We want to avoid merge conflicts in storyboards and settings files, therefore we try to avoid working on storyboards simultaneously.

## Storyboards

Always define a storyboard identifier for a storyboard scene.

Be very "clean" with Autolayout. That means an element should have ONLY the necessary constraints and not **more** than those. Try to find the setup, which requires the least number of constraints to achieve the desired layout, which will work for all screen sizes (including iPad).

The same is true for all other properties and settings you define in the storyboard: always try to **ONLY** set the necessary properties. As much as possible shall use the default values (remain untouched).

Constraint values shall also always prefer the standard values over any specified "hard" numbers. Most can be achieved without entering any specific number.

Try always to finish the task you do on a storyboard. That means: Connect all outlets and actions to the corresponding ViewController. If the functionality of the action is not determined at the time of implementation in the storyboard, we still want the action to be defined in the storyboard and call an empty method in the ViewController subclass. The body of that method, shall contain a `//TODO:` comment with information, what is still missing (ideally with a corresponding Redmine ticket number! If no ticket can be found, which describes the missing task, please request the creation of such a Redmine Ticket)

Make sure, there are no "orphaned/unused" elements in your storyboard scene! Controls shall always be connected to actions, non-static elements shall always be connected to outlets.

## Unused asset or code

Any unused asset or class file or code shall be deleted as soon as it get's out of use. *Don't keep unused code or files in the project, just for _eventual_ future use!* We have everything under source control and can get it back at any time. Add a comment about deleted files or deleted functionality to the commit message, so the commit can easily be found to restore it, if we need it in the future.
## Assets

### Images
Images shall be added to the appropriate xcasset object. There shall always be all required versions of the image assets (1x, 2x and 3x). If there are missing assets, please use dummy assets. E.g. if you do not have all three resolutions, just create them by scaling them up and ideally watermark them (Can be easily done in "Preview" app with the resize tool and the annotation tools).

