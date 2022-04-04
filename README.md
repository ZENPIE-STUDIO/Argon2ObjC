# Argon2ObjC

[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

使用 **[Password Hashing Competition](https://www.password-hashing.net)** 的冠軍 **[Argon2](https://github.com/P-H-C/phc-winner-argon2)** ，計算密碼的Hash值。它是 Memory-hard hash function，如果想要破解就需要大量 Memory及計算資源。

PS1. 此Framework是我用來簡化呼叫參數。

PS2. 用Swift開發的人，請這邊走 [Argon2Swift](https://github.com/tmthecoder/Argon2Swift)



### Installation

- [Swift Package Manager](https://swift.org/package-manager/)  (Binary Framework / xcframework)
  1. File > Swift Packages > Add Package Dependency
  2. Copy & paste `https://github.com/ZENPIE-STUDIO/Argon2ObjC` then follow the instruction

### Usage

```objc
#import <Argon2ObjC/Argon2ObjC.h>
//#import <Argon2ObjC_macOS/Argon2ObjC_macOS.h> // for macOS

NSMutableData* rawBuf = [NSMutableData new];
NSMutableString* encodedString = [NSMutableString new];
    
Argon2Hash* argon2 = [[Argon2Hash alloc] init];
BOOL result1 = [argon2 hashPassword:@"password" withSalt:@"salt" OutputRawData:rawBuf Encoded:encodedString];
    
BOOL result2 = [argon2 verifyPassword:@"password" withEncoded:encodedString];
```





### License

Argon2ObjC is published under the [MIT License](./LICENSE).
