# Script

## bootstrap

1. Delete `ExampleTests` Add `Tests` can use default Podfile,remember clean scheme.
2. Add Created folder in project group.

## Tests

```
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble-Swift.h>

// "Enable Modules" to NO. '__Verify' is invalid in C99
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
```

> Tips: Objective-C++ not support @import.

```
@import Quick;
@import Nimble;
```

## Archive command `Xcode7`

xcodebuild -exportArchive -archivePath
~/Developer/Example/build/Archive/Example.xcarchive -exportPath
~/Developer/Example/build/Archive/ -exportOptionsPlist
exportPlist.plist | xcpretty

## Updating 

* ext 
* Podfile

## Recipes

* Merges with Xcode is faster than scripts. `develop branch`
* Recommend use scripts(test/archive/run) before release `master branch`

## Reference

* [objc-build-scripts](https://github.com/jspahrsummers/objc-build-scripts)
* [KZBootstrap](https://github.com/krzysztofzablocki/KZBootstrap)
* [xcconfigs](https://github.com/jspahrsummers/xcconfigs)
* [craftercconfigs](https://github.com/krzysztofzablocki/craftercconfigs)
