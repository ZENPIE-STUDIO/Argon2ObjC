//
//  Argon2ObjCTests.m
//  Argon2ObjCTests
//
//  Created by EddieHua on 2022/3/28.
//

#import <XCTest/XCTest.h>
#import "../../Argon2ObjC/Argon2Hash.h"

@interface Argon2ObjCTests : XCTestCase

@end

@implementation Argon2ObjCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [Argon2Hash hashPassword:@"password" withType:Argon2_id Salt:@"somesalt" Memory:256 Iterations:32 Parallelism:2];

    NSMutableData* rawBuf = [NSMutableData new];
    NSMutableString* encodedString = [NSMutableString new];
    
    Argon2Hash* argon2 = [[Argon2Hash alloc] init];
    BOOL result1 = [argon2 hashPassword:@"password" withSalt:@"somesalt" OutputRawData:rawBuf Encoded:encodedString];
    XCTAssert(result1);
    
    BOOL result2 = [argon2 verifyPassword:@"password" withEncoded:encodedString];
    XCTAssert(result2);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
