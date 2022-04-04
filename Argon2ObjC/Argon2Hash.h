//
//  Argon2Hash.h
//  Argon2ObjC
//
//  Created by EddieHua on 2022/3/28.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Argon2Type)
{
    // Argon2d maximizes resistance to GPU cracking attacks. It accesses the memory array in a password dependent order, which reduces the possibility of time–memory trade-off (TMTO) attacks, but introduces possible side-channel attacks.
    Argon2_d  = 0,
    
    // Argon2i is optimized to resist side-channel attacks. It accesses the memory array in a password independent order.
    Argon2_i  = 1,
    
    // Argon2id is a hybrid version. It follows the Argon2i approach for the first half pass over memory and the Argon2d approach for subsequent passes. The RFC[4] recommends using Argon2id if you do not know the difference between the types or you consider side-channel attacks to be a viable threat.
    Argon2_id = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface Argon2Hash : NSObject

// The specific type to use, either`Argon2_i`, `Argon2_d`, or `Argon2_id`
@property (nonatomic) Argon2Type type;     // (defaults to `Argon2_id`)

// The amount of iterations that the algorithm should perform.
@property (nonatomic) uint32_t iterations;  // defaults to 32

// The amount of memory the hashing operation can use at a maximum.
@property (nonatomic) uint32_t memory;      // defaults to 256

// The factor of parallelism when comouting the hash.
@property (nonatomic) uint32_t parallelism; // defaults to 2

// The length of the final hash.
@property (nonatomic) uint32_t length;  // defaults to 32

// The version to use in the hashing computation, either `V10 (0x10)` or `V13 (0x13)`
@property (nonatomic) uint32_t version; // defaults to v13 (0x13)

/**
 * Password Hashing With Salt.
 * @param password The `String` password to hash (utf-8 encoded)
 * @param salt The `Salt` to use with Argon2 as the salt in the hashing operation
 * @param hashBuffer The computed hash.
 * @param encodedString The encoded computation with all information as a readable String.
 * @return YES(Success), NO(Failed)
 */
- (BOOL) hashPassword:(NSString*) password
             withSalt:(NSString*) salt
        OutputRawData:(NSMutableData*) hashBuffer
              Encoded:(NSMutableString*) encodedString;

/**
 * Verifies a password with the given encoded String, returning `YES` on successful verifications and `NO` on incorrect ones.
 * @param password The `String` password to hash (utf-8 encoded)
 * @param encodedString The encoded computation with all information as a readable String.
 * @return A `BOOL` signifying whether the password is equivalent to the hash or not.
 */
- (BOOL) verifyPassword:(NSString*) password
            withEncoded:(NSString*) encodedString;



/// Hashes a given password with Argon2 utilizing the given salt as well as optionally the specific parameters of the hashing operation itself.
+ (NSData*) hashPassword:(NSString*) password
                withType:(Argon2Type) type
                    Salt:(NSString*) salt
                  Memory:(uint32_t) memory
              Iterations:(uint32_t) iterations
             Parallelism:(uint32_t) parallelism;
@end

NS_ASSUME_NONNULL_END
