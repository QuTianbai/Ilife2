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

> 由于Objective-C++ 不支持@import只能才用上面的方式导入

```
@import Quick;
@import Nimble;
```

## Archive command

xcodebuild -exportArchive -archivePath
~/Developer/Finance/build/Archive/Finance.xcarchive -exportPath
~/Developer/Finance/build/Archive/ -exportOptionsPlist
exportPlist.plist   | xcpretty

## Updating 

* ext 
* podfile

## Reference

* [objc-build-scripts](https://github.com/jspahrsummers/objc-build-scripts)
* [KZBootstrap](https://github.com/krzysztofzablocki/KZBootstrap)
* [xcconfigs](https://github.com/jspahrsummers/xcconfigs)
* [craftercconfigs](https://github.com/krzysztofzablocki/craftercconfigs)
