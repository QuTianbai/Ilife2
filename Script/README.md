# Script

## Build Version Script

1. Set build version number `1`
2. Create `New Run Script Phase` with the code:

    "${SRCROOT}/Script/xcode-build-bump.sh"

> Lock(git lock) Info.plist avoid commit build version every times.
> Before merge branch unlock Info.plist

## bootstrap

1. Delete `ExampleTests` Add Tests can use default Podfile,remmember clean scheme.
2. Add Created folder in project group.

## Tests

  #import <Nimble/Nimble.h>
  #import <Quick/Quick.h>
  #import <Nimble/Nimble-Swift.h>

  // "Enable Modules" to NO. '__Verify' is invalid in C99
  #define MOCKITO_SHORTHAND
  #import <OCMockito/OCMockito.h> 

## Reference

[objc-build-scripts]https://github.com/jspahrsummers/objc-build-scripts
https://github.com/krzysztofzablocki/KZBootstrap
https://github.com/jspahrsummers/xcconfigs
https://github.com/krzysztofzablocki/craftercconfigs
