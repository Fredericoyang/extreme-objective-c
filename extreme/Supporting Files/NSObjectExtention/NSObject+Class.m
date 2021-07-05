//
//  NSObject+Class.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/5.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "NSObject+Class.h"
#import <objc/runtime.h>

@implementation PropertyModel

@end


@implementation NSObject (Class)

BOOL isClassOfFoundation(Class cls){
    __block BOOL result = NO;
    NSSet *classesOfFoundation = [[NSSet alloc] initWithObjects:
                                         @"NSURL",
                                         @"NSDate",
                                         @"NSValue",
                                         @"NSData",
                                         @"NSError",
                                         @"NSArray",
                                         @"NSDictionary",
                                         @"NSString",
                                         @"NSAttributedString",
                                         nil];
    [classesOfFoundation enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        if ([cls isSubclassOfClass:NSClassFromString(obj)] || (cls == [NSObject class])) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


- (void)enumerateClass:(EnumerateClass)enumerateClass {
    if (!enumerateClass) {
        return;
    }
    BOOL stop = NO;
    Class cls = self.class;
    while (cls && !stop) {
        enumerateClass(cls, &stop);
        cls = class_getSuperclass(cls);
        if (isClassOfFoundation(cls)) {
            break;
        }
    }
}

- (void)enumerateProperties:(Class _Nonnull)cls finish:(EnumeratePropertiesFinish)finish {
    if (!finish) {
        return;
    }
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    for (NSInteger i=0; i<count; i++) {
        objc_property_t p = properties[i];
        NSString *name = @(property_getName(p));
        NSString *attribute = @(property_getAttributes(p));
        NSRange separatorLocation = [attribute rangeOfString:@","];
        NSString *attributeTypeString ;
        if (separatorLocation.location == NSNotFound) {
            attributeTypeString = [attribute substringFromIndex:1];
        }
        else {
            attributeTypeString = [attribute substringWithRange:NSMakeRange(1, separatorLocation.location-1)];
        }
        PropertyModel *model = [[PropertyModel alloc] init];
        model.propertyName = name;
        model.propertyType = attributeTypeString;
        finish(model);
    }
    free(properties);
}

@end
