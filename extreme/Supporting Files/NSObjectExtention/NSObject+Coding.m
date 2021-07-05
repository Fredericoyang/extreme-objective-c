//
//  NSObject+Coding.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/5.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "NSObject+Coding.h"
#import <objc/runtime.h>
#import "EFMacros.h"
#import "JSONModel.h"
#import "NSObject+Class.h"

@implementation NSObject (Coding)

- (void)enumPropertiesCoding:(EnumerateBaseDataModelProperties)enumerateBaseDataModelProperties {
    [self enumerateClass:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (cls == [JSONModel class]) {
            return;
        }
        [self enumerateProperties:cls finish:^(PropertyModel *pModel) {
            NSString *attributeTypeString = pModel.propertyType;
            NSString *name = pModel.propertyName;
            Class attributeClass;
            if ([attributeTypeString hasPrefix:@"@\""]) {
                attributeTypeString = [attributeTypeString substringWithRange:NSMakeRange(2, attributeTypeString.length-3)];
                if ([attributeTypeString containsString:@"<"]) {
                    NSArray *separate_classes = [attributeTypeString componentsSeparatedByString:@"<"];
                    attributeTypeString = separate_classes[0];
                }
                attributeClass = NSClassFromString(attributeTypeString);
                NSAssert(class_conformsToProtocol(cls, NSProtocolFromString(@"NSSecureCoding")), STRING_FORMAT(@"Model:%@ 不合规，原因：没有实现 NSSecureCoding 代理。", cls));
            }
            if (attributeClass && enumerateBaseDataModelProperties) {
                enumerateBaseDataModelProperties(attributeClass, nil, name, [self valueForKey:name]);
            }
        }];
    }];
}


- (void)coding_encode:(NSCoder *_Nonnull)aCoder {
    [self enumPropertiesCoding:^(Class attribute_class, Class model_class, id key, id value) {
        [aCoder encodeObject:value forKey:key];
    }];
}

- (nullable instancetype)coding_secureDecode:(NSCoder *_Nonnull)aDecoder {
    [self enumPropertiesCoding:^(Class attribute_class, Class model_class, id key, id value) {
        [self setValue:[aDecoder decodeObjectOfClass:[attribute_class class] forKey:key] forKey:key];
    }];
    return self;
}

@end
