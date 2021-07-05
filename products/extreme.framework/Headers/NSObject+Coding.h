//
//  NSObject+Coding.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/5.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coding)

typedef void (^_Nullable EnumerateBaseDataModelProperties)(Class _Nonnull attribute_class, Class _Nullable model_class, id _Nonnull key, id _Nullable value);

- (void)coding_encode:(NSCoder *_Nonnull)aCoder;
- (nullable instancetype)coding_secureDecode:(NSCoder *_Nonnull)aDecoder;

@end

#define CodingImplmentation \
+ (BOOL)supportsSecureCoding { \
    return YES; \
} \
 \
- (void)encodeWithCoder:(NSCoder *_Nonnull)aCoder { \
    [self coding_encode:aCoder]; \
} \
 \
- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder { \
    if (self == [super init]) { \
        [self coding_secureDecode:aDecoder]; \
    } \
    return self; \
} \
